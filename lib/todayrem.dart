import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_bar.dart';
import 'fortheday.dart';
import 'imprem.dart';
import 'rem.dart';
import 'recyclebin.dart';

class TodayReminderPage extends StatefulWidget {
  @override
  _TodayReminderPageState createState() => _TodayReminderPageState();
}

class _TodayReminderPageState extends State<TodayReminderPage> {
  late List<Map<String, dynamic>> _todayReminders = [];
  late List<Map<String, dynamic>> _foundReminders = [];
  bool _isSearching = false;
  late TextEditingController _textEditingController = TextEditingController();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchTodayReminders();
  }

  void _fetchTodayReminders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reminders')
          .where('user_email', isEqualTo: currentUser.email)
          .get();
      DateTime today = _startOfToday();
      setState(() {
        _todayReminders = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((reminder) {
          DateTime reminderDate = (reminder['date'] as Timestamp).toDate();
          return reminderDate.year == today.year &&
              reminderDate.month == today.month &&
              reminderDate.day == today.day;
        }).toList();
        _foundReminders = _todayReminders;
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _todayReminders;
    } else {
      results = _todayReminders
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
      Navigator.pop(context);
    } else if (index == 2) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ImportantReminderPage()),
      );
    } 
    else if (index == 3) {
      Navigator.push(
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
          'Today\'s Reminders',
        ),
        backgroundColor: Color.fromARGB(255, 241, 239, 239),
        actions: _isSearching
            ? [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _foundReminders = _todayReminders;
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
                      ?ListView.builder(
                      itemCount: _foundReminders.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> reminder = _foundReminders[index];
                        return Card(
                          elevation: 4, // Adjust the elevation for the raised effect
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Set circular border radius
                          ),
                          color: Color(0xff7E1636), // Set the background color to red
                          child: ListTile(
                            tileColor: Color(0xff7E1636), // Set the color of the ListTile
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Set circular border radius
                            ),
                            title: Text(
                              reminder['event_name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              reminder['event_description'],
                              style: TextStyle(color: Colors.white),
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
                  centerWidget: ForTheDay(),
                  ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper function to get the start of today's date
  DateTime _startOfToday() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
