import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore
import 'back2_scaffold.dart';
import 'main.dart'; // Import the main.dart file

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUsernameUnique(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('name', isEqualTo: username)
          .get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      throw e;
    }
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String emergencyContact,
    required bool setForAllReminders,
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'emergencyContact': emergencyContact,
        'setForAllReminders': setForAllReminders,
      });
    } catch (e) {
      throw e;
    }
  }
}

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();
  bool setForAllReminders = false;
  bool passwordObscured = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreService = FirestoreService();

  void createUser() async {
    try {
      bool isUnique = await firestoreService.isUsernameUnique(nameController.text);
      if (!isUnique) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username is already in use'),
          ),
        );
        return;
      }

      await firestoreService.createUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        emergencyContact: emergencyContactController.text,
        setForAllReminders: setForAllReminders,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User created successfully!'),
        ),
      );
      
      // Navigate back to the main.dart page
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Back2Scaffold(
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nEnter Details!',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned.fill(
            top: 200.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xffB81736), // Pink color
                            ),
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Color(0xffB81736), // Pink color
                            ),
                            labelText: 'Email id',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: passwordObscured,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xffB81736), // Pink color
                            ),
                            suffixIcon: IconButton(onPressed:(){
                              setState(() {
                                passwordObscured = !passwordObscured;
                              });
                            },
                             icon: Icon(
                              passwordObscured ?
                              Icons.visibility_off : Icons.visibility,color:Colors.grey),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: emergencyContactController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Color(0xffB81736), // Pink color
                            ),
                            labelText: 'Emergency contact',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.info,
                                color: Colors.grey, // Adjust icon color as needed
                              ),
                              onPressed: () {
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Set a contact to check on you for any unattended reminders',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20), // Customize text color
                                  ),
                                  backgroundColor: Color(
                                      0xffB81736), // Customize background color
                                  duration: Duration(
                                      seconds: 3), // Optional: set the duration
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Set for all reminders',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xffB81736),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            CupertinoSwitch(
                              value: setForAllReminders,
                              onChanged: (bool newValue) {
                                setState(() {
                                  setForAllReminders = newValue;
                                });
                              },
                              activeColor:
                                  Color(0xffB81736), // Pink color
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: createUser,
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
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
                                ]),
                            child: Center(
                              child: Text(
                                'Confirm',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
