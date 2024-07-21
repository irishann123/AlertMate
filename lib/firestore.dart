import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _remindersCollection =
      FirebaseFirestore.instance.collection('reminders');
  final CollectionReference _deletedRemindersCollection =
      FirebaseFirestore.instance.collection('deletedreminders'); // New collection for deleted reminders
  final CollectionReference _todoCollection =
      FirebaseFirestore.instance.collection('todo'); // Collection for todo lists

  Future<bool> isUsernameUnique(String username) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('name', isEqualTo: username).get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Failed to check username uniqueness: $e');
    }
  }

  Future<String> createUser({
    required String name,
    required String email,
    required String password,
    required String emergencyContact,
    required bool setForAllReminders,
  }) async {
    try {
      bool isUnique = await isUsernameUnique(name);
      if (!isUnique) {
        throw Exception('Username is already in use');
      }

      // Add user to the 'users' collection
      DocumentReference userDocRef = await _usersCollection.add({
        'name': name,
        'email': email,
        'password': password,
        'emergency_contact': emergencyContact,
        'set_for_all_reminders': setForAllReminders,
      });

      // Return the document ID of the newly created user
      return userDocRef.id;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> addReminder({
    required String userId,
    required String eventName,
    required String eventDescription,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String repeatInterval,
    required String emergencyContact,
    required String userEmail,
    required bool isImportant,
  }) async {
    try {
      String startTimeString =
          '${startTime.hour}:${startTime.minute}'.padLeft(5, '0');
      String endTimeString =
          '${endTime.hour}:${endTime.minute}'.padLeft(5, '0');

      await _remindersCollection.add({
        'userId': userId,
        'event_name': eventName,
        'event_description': eventDescription,
        'date': date,
        'start_time': startTimeString,
        'end_time': endTimeString,
        'repeat_interval': repeatInterval,
        'emergency_contact': emergencyContact,
        'user_email': userEmail,
        'important': isImportant,
      });
    } catch (e) {
      throw Exception('Failed to add reminder: $e');
    }
  }

  Future<void> moveDeletedReminder(Map<String, dynamic> reminderData) async {
    try {
      await _deletedRemindersCollection.add(reminderData);
    } catch (e) {
      throw Exception('Failed to move deleted reminder: $e');
    }
  }

  Future<void> addTodoList({
    required String userId,
    required String email,
    required Map<String, dynamic> lists,
  }) async {
    try {
      await _todoCollection.doc('to do').set({
        userId: {
          'email': email,
          'lists': lists,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to add todo list: $e');
    }
  }

  Future<void> addTodoItem({
    required String userId,
    required String listId,
    required Map<String, dynamic> item,
  }) async {
    try {
      await _todoCollection.doc('to do').update({
        '$userId.lists.$listId.items': FieldValue.arrayUnion([item])
      });
    } catch (e) {
      throw Exception('Failed to add todo item: $e');
    }
  }
}
