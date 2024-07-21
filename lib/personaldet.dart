import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'background_scaffold.dart';
import 'bottom_bar.dart';
import 'personcenter.dart';
import 'alert.dart';

class PersonalDetailsPage extends StatefulWidget {
  @override
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  bool _toggleValue = false;
  bool? _hasBioSensor;
  late TextEditingController controller;
  LocalAuthentication authentication = LocalAuthentication();
  String num = 'Loading...';
  String userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _fetchUserData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await authentication.canCheckBiometrics;
      print(_hasBioSensor);
      if (_hasBioSensor!) {
        _getAuth();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
        localizedReason: 'Scan your fingerprint to proceed',
        options: AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (isAuth) {
        final newNum = await openDialog();
        if (newNum == null || newNum.isEmpty) return;

        // Update emergency contact number in Firestore
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'emergencyContact': newNum});
        }

        setState(() {
          num = newNum;
        });
      }
      print(isAuth);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit Contact Info'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter New Contact Number'),
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: submit,
              child: Text('SUBMIT'),
            )
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop(controller.text);
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('User email: ${user.email}');
      try {
        // Fetch user data from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          // Extract user data
          setState(() {
            userName = userSnapshot.get('name');
            num = userSnapshot.get('emergencyContact');
            _toggleValue = userSnapshot.get('setForAllReminders') ?? false;
          });
        } else {
          print('User document not found for UID: ${user.uid}');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No user logged in');
    }
  }

  Future<void> _updateSetForAllReminders(bool value) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'setForAllReminders': value});
      setState(() {
        _toggleValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: 'Personal Details',
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    'Name: ${userName.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial', // Change to the desired font family
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 2),
                  Text(
                    'Emergency Contact: $num',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _checkBio();
                    },
                    child: Container(
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffB81736),
                            Color(0xff281537),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(' Set for all Reminders:', style: TextStyle(fontSize: 21)),
                  SizedBox(width: 10),
                  Switch(
                    activeColor: Color.fromARGB(255, 250, 244, 255),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Color(0xff281537),
                    value: _toggleValue,
                    onChanged: (value) {
                      _updateSetForAllReminders(value);
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: BottomBar(
                centerWidget: PersonCenter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
