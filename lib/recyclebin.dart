import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart'; // Import Firestore service

class RecycleBinPage extends StatefulWidget {
  @override
  _RecycleBinPageState createState() => _RecycleBinPageState();
}

class _RecycleBinPageState extends State<RecycleBinPage> {
  late List<Map<String, dynamic>> _deletedReminders = [];

  @override
  void initState() {
    super.initState();
    _fetchDeletedReminders();
  }

  void _fetchDeletedReminders() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('deletedreminders')
          .get();
      setState(() {
        _deletedReminders = querySnapshot.docs.map<Map<String, dynamic>>((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final Map<String, dynamic> reminderData = {'doc_id': doc.id};

          if (data != null) {
            data.forEach((key, value) {
              if (value != null) {
                reminderData[key] = value;
              }
            });
          }

          return reminderData;
        }).toList();
      });
    } catch (e) {
      print('Error fetching deleted reminders: $e');
    }
  }

  void _recoverReminder(String docId) async {
    print('Recovering reminder with docId: $docId');

    // Optimistic UI update
    setState(() {
      _deletedReminders.removeWhere((reminder) => reminder['doc_id'] == docId);
    });

    try {
      // Fetch the reminder data from deletedreminders collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('deletedreminders')
          .where('doc_id', isEqualTo: docId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot reminderSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? reminderData = reminderSnapshot.data() as Map<String, dynamic>?;

        if (reminderData != null) {
          print('Reminder data: $reminderData');

          // Add the reminder back to reminders collection
          await FirebaseFirestore.instance
              .collection('reminders')
              .add(reminderData);

          // Delete the reminder from deletedreminders collection
          await reminderSnapshot.reference.delete();

          // No need to refresh the UI here as it's already updated optimistically
        } else {
          print('Reminder data is null');
        }
      } else {
        print('Reminder with docId $docId does not exist in deletedreminders collection');
      }
    } catch (e) {
      print('Error recovering reminder: $e');
      // If an error occurs, you may need to revert the optimistic update
      // Or provide some error handling to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Bin'),
        backgroundColor: Color.fromARGB(255, 241, 239, 239),
      ),
      body: _deletedReminders.isNotEmpty
          ? ListView.builder(
              itemCount: _deletedReminders.length,
              itemBuilder: (context, index) {
                final reminderData = _deletedReminders[index];
                final title = reminderData['event_name'];
                DateTime date = reminderData['date'].toDate();
                String docId = reminderData['doc_id'];
                return Card(
                  key: ValueKey(docId),
                  color: Color(0xff7E1636),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      title != null ? title.toUpperCase() : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${_formatDate(date)} at ${reminderData["start_time"] != null ? reminderData["start_time"] : ''}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _recoverReminder(docId),
                      child: Text('Recover'),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('No deleted reminders found'),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
