import 'package:alertmate/impcenter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_bar.dart';
import 'impcenter.dart'; 
import 'rem.dart';
import 'recyclebin.dart';
import 'todayrem.dart';

class ImportantReminderPage extends StatefulWidget {
  @override
  _ImportantReminderPageState createState() => _ImportantReminderPageState();
}

class _ImportantReminderPageState extends State<ImportantReminderPage> {
  late TextEditingController _textEditingController = TextEditingController();
  late List<Map<String, dynamic>> _importantReminders = [];
  late List<Map<String, dynamic>> _foundReminders = [];
  bool _isSearching = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchImportantReminders();
  }

  void _fetchImportantReminders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reminders')
          .where('user_email', isEqualTo: currentUser.email)
          .where('important', isEqualTo: true)
          .get();
      setState(() {
        _importantReminders = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _foundReminders = _importantReminders;
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _importantReminders;
    } else {
      results = _importantReminders
          .where((reminder) => reminder["event_name"] != null && reminder["event_name"].toString().toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundReminders = results;
      _isSearching = enteredKeyword.isNotEmpty;
    });

    if (!_isSearching) {
      _clearTextField();
    }
  }

  void _clearTextField() {
    _textEditingController.clear();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onDrawerItemTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllReminderPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TodayReminderPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ImportantReminderPage()),
      );
    } 
    else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RecycleBinPage()), // Navigate to Recycle Bin page
      );
    }
      else {
      setState(() {
        _selectedIndex = index;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _selectedIndex = -1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Important',
        ),
        backgroundColor: Color.fromARGB(255, 241, 239, 239),
        actions: _isSearching
            ? [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _foundReminders = _importantReminders;
                      _isSearching = false;
                    });
                    _clearTextField();
                  },
                ),
              ]
            : [],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              ListTile(
                onTap: () => _onDrawerItemTap(0),
                selected: _selectedIndex == 0,
                leading: Icon(Icons.menu),
                title: Text('All'),
              ),
              ListTile(
                onTap: () => _onDrawerItemTap(1),
                selected: _selectedIndex == 1,
                leading: Icon(Icons.today),
                title: Text('Today'),
              ),
              ListTile(
                onTap: () => _onDrawerItemTap(2),
                selected: _selectedIndex == 2,
                leading: Icon(Icons.star),
                title: Text('Important'),
              ),
              ListTile(
                onTap: () => _onDrawerItemTap(3),
                selected: _selectedIndex == 3,
                leading: Icon(Icons.delete),
                title: Text('Recycle Bin'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _textEditingController,
                        onChanged: (value) => _runFilter(value),
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: _foundReminders.isNotEmpty
                            ? ListView.builder(
                          itemCount: _foundReminders.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> reminder = _foundReminders[index];
                            Timestamp timestamp = reminder['date'] as Timestamp; // Fetching Timestamp from Firestore
                            DateTime dateTime = timestamp.toDate(); // Converting Timestamp to DateTime
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              color: Color(0xff7E1636), // Set the color of the Card
                              child: ListTile(
                                title: Text(
                                  reminder['event_name'],
                                  style: TextStyle(color: Colors.white), // Set text color
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reminder['event_description'],
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                    Text(
                                      'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                                      style: TextStyle(color: Colors.white),// Set text color
                                    ),
                                    Text(
                                      'Time: ${reminder['start_time']}',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )

                            : const Text(
                                'No results found',
                                style: TextStyle(fontSize: 24),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: BottomBar(
                  centerWidget: ImpCenter(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
