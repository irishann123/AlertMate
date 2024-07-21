import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart'; // import Flutter TTS plugin

bool isSpeechInitiated = false; // Flag to track if speech is initiated
FlutterTts flutterTts = FlutterTts(); // Declare FlutterTts object outside the function

// Map to store whether alert is shown for each reminder
Map<String, bool> alertShownMap = {};

Future<void> checkRemindersAndShowAlert(BuildContext context, String userEmail) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current time
  DateTime now = DateTime.now();
  String currentTime = DateFormat('HH:mm').format(now);

  // Reset the map at the beginning of each check
  alertShownMap.clear();

  // Retrieve reminders with alert time equal to the current time and for the current user
  QuerySnapshot querySnapshot = await _firestore
      .collection('reminders')
      .where('start_time', isEqualTo: currentTime)
      .where('user_email', isEqualTo: userEmail) // Filter reminders for the current user
      .get();

  // If there are reminders with alert time equal to the current time for the current user
  if (querySnapshot.docs.isNotEmpty && !isSpeechInitiated) {
    // Display an alert box for each reminder, but only once for each reminder
    for (DocumentSnapshot document in querySnapshot.docs) {
      String reminderId = document.id;
      if (alertShownMap[reminderId] != true) {
        String eventName = document['event_name'];
        String eventDescription = document['event_description'];

        // Mark the alert as shown for this reminder
        alertShownMap[reminderId] = true;

        // Speak the event description using Flutter TTS
        await speakEventDescription(context, eventDescription); // Pass context to access Navigator

        // Show the alert box
        await showDialog(
          context: context,
          barrierDismissible: false, // Prevent dialog from being dismissed by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(eventName), // Use event_name as the title
              content: Text(eventDescription), // Use event_description as the content
              actions: [
                TextButton(
                  onPressed: () {
                    stopSpeech(); // Stop speech when the alert box is closed
                    Navigator.pop(context); // Close the alert box
                    alertShownMap[reminderId] = false; // Reset the flag when alert box is closed
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
    isSpeechInitiated = true; // Set the flag to true after the speech is initiated
  }
}


// Function to speak the event description using Flutter TTS
Future<void> speakEventDescription(BuildContext context, String eventDescription) async {
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1);
  await flutterTts.speak(eventDescription);
}

// Function to stop the speech
void stopSpeech() {
  flutterTts.stop();
  isSpeechInitiated = false; // Reset the flag when speech is stopped
}

// Schedule periodic checks
void startAlertChecks(BuildContext context, String userEmail) {
  Timer.periodic(Duration(minutes: 1), (timer) {
    // Reset the flag before checking reminders
    isSpeechInitiated = false;
    checkRemindersAndShowAlert(context, userEmail);
  });
}

// Retrieve current user's email
String getCurrentUserEmail() {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  if (user != null) {
    return user.email ?? ''; // Return user's email or empty string if not available
  } else {
    // Handle case where user is not signed in
    return ''; // or throw an error, depending on your app's logic
  }
}