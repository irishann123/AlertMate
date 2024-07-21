import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  String? eventName;
  String? eventDescription;
  DateTime? date;
  String? startTime;
  String? endTime;
  String? repeatInterval;
  String? emergencyContact;
  String? userEmail;
  bool? isImportant;

  ReminderModel({
    this.eventName,
    this.eventDescription,
    this.date,
    this.startTime,
    this.endTime,
    this.repeatInterval,
    this.emergencyContact,
    this.userEmail,
    this.isImportant,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventDescription': eventDescription,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'repeatInterval': repeatInterval,
      'emergencyContact': emergencyContact,
      'userEmail': userEmail,
      'isImportant': isImportant,
    };
  }

  factory ReminderModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ReminderModel(
      eventName: data['event_name'],
      eventDescription: data['event_description'],
      date: data['date'],
      startTime: data['start_time'],
      endTime: data['end_time'],
      repeatInterval: data['repeat_interval'],
      emergencyContact: data['emergency_contact'],
      userEmail: data['user_email'],
      isImportant: data['important'],
    );
  }
}
