import 'package:alertmate/newtask2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_bar.dart';
import 'AddRem2.dart';
import 'newtask2.dart';
import 'deleterem.dart';
import 'todayrem.dart'; // Import today's reminders page
import 'imprem.dart'; // Import important reminders page
import 'firestore.dart'; // Import Firestore service
import 'recyclebin.dart';
import 'alert.dart';

class AllReminderPage extends StatefulWidget {
  AllReminderPage({Key? key}) : super(key: key);

  @override
  _AllReminderPageState createState() => _AllReminderPageState();
}

class _AllReminderPageState extends State<AllReminderPage> {
  late TextEditingController _textEditingController = TextEditingController();
  late User? _currentUser;
  late List<Map<String, dynamic>> _allUsers = [];
  late List<Map<String, dynamic>> _foundUsers = [];
  bool _isSearching = false;
  int _selectedIndex = -1;
  List<String> _selectedTitles = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
        if (_currentUser != null) {
          _fetchReminders();
        }
      });
    });
  }

  void _fetchReminders() async {
    if (_currentUser != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reminders')
          .where('user_email', isEqualTo: _currentUser!.email)
          .get();
      setState(() {
        _allUsers = querySnapshot.docs.map<Map<String, dynamic>>((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final Map<String, dynamic> userData = {'doc_id': doc.id};

          if (data != null) {
            data.forEach((key, value) {
              if (value != null) {
                userData[key] = value;
              }
            });
          }

          return userData;
        }).toList();

        _foundUsers = _allUsers;
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["event_name"] != null &&
              user["event_name"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
      _isSearching = enteredKeyword.isNotEmpty;
    });

    if (!_isSearching) {
      _clearTextField();
    }
  }

  void _clearTextField() {
    _textEditingController.clear();
  }

  void _onDrawerItemTap(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AllReminderPage()), // Navigate to today's reminders page
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TodayReminderPage()), // Navigate to today's reminders page
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ImportantReminderPage()), // Navigate to important reminders page
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RecycleBinPage()), // Navigate to Recycle Bin page
      );
    } else {
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

  void _deleteItems(List<Map<String, dynamic>> updatedList) {
    setState(() {
      for (Map<String, dynamic> user in updatedList) {
        _allUsers.removeWhere(
            (existingUser) => existingUser['doc_id'] == user['doc_id']);
      }
      _foundUsers.removeWhere((user) => updatedList
          .any((updatedUser) => updatedUser['doc_id'] == user['doc_id']));
    });
  }

  void _onCardLongPress(String title) {
    setState(() {
      if (_selectedTitles.contains(title)) {
        _selectedTitles.remove(title);
      } else {
        _selectedTitles.add(title);
      }
    });
  }

  void _deleteSelectedReminders(
      List<Map<String, dynamic>> selectedReminders) async {
    try {
      for (var reminder in selectedReminders) {
        // Move the deleted reminder to the deletedreminders collection
        await FirestoreService().moveDeletedReminder(reminder);

        // Delete the reminder from the reminders collection
        await FirebaseFirestore.instance
            .collection('reminders')
            .doc(reminder['doc_id'])
            .delete();
      }

      // After successful deletion, update the UI or perform any necessary actions
      setState(() {
        // Remove the selected reminders from the UI
        _deleteItems(selectedReminders);
        // Clear the list of selected titles since the reminders are deleted
        _selectedTitles.clear();
      });

      // Optionally, show a message indicating successful deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Selected reminders deleted successfully'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting reminders: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete selected reminders'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = getCurrentUserEmail(); // Retrieve current user's email
    startAlertChecks(context, userEmail);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All',
        ),
        backgroundColor: Color.fromARGB(255, 241, 239, 239),
        actions: _isSearching
            ? [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _foundUsers = _allUsers;
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
              for (int i = 0; i < drawerItems.length; i++)
                GestureDetector(
                  onTap: () => _onDrawerItemTap(i),
                  child: Container(
                    color: _selectedIndex == i ? Color(0xff7E1636) : null,
                    child: ListTile(
                      leading: Icon(drawerItems[i].icon),
                      title: Text(drawerItems[i].title),
                    ),
                  ),
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
                        child: _foundUsers.isNotEmpty
                            ? DeleteRem(
                                allUsers: _foundUsers,
                                onDelete: _deleteItems,
                                onLongPress: _onCardLongPress,
                                selectedTitles: _selectedTitles,
                                onDeleteSelected: _deleteSelectedReminders,
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
                  centerWidget: AddRem2(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;

  DrawerItem({required this.title, required this.icon});
}

final List<DrawerItem> drawerItems = [
  DrawerItem(title: 'All', icon: Icons.menu),
  DrawerItem(title: 'Today', icon: Icons.today),
  DrawerItem(title: 'Important', icon: Icons.star),
  DrawerItem(title: 'Recycle Bin', icon: Icons.delete),
];

class DeleteRem extends StatefulWidget {
  final List<Map<String, dynamic>> allUsers;
  final Function(List<Map<String, dynamic>>) onDelete;
  final Function(String) onLongPress;
  final List<String> selectedTitles;
  final Function(List<Map<String, dynamic>>) onDeleteSelected;

  const DeleteRem({
    Key? key,
    required this.allUsers,
    required this.onDelete,
    required this.onLongPress,
    required this.selectedTitles,
    required this.onDeleteSelected,
  }) : super(key: key);

  @override
  _DeleteRemState createState() => _DeleteRemState();
}

class _DeleteRemState extends State<DeleteRem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.selectedTitles.isNotEmpty
              ? () {
                  print('Delete button pressed');
                  final selectedReminders =
                      _convertSelectedTitlesToMapList(widget.selectedTitles);
                  print('Selected reminders: $selectedReminders');
                  widget.onDeleteSelected(selectedReminders);
                  print('onDeleteSelected called');
                  setState(() {
                    widget.selectedTitles.clear();
                  });
                  print('Selected titles cleared: ${widget.selectedTitles}');
                }
              : null,
          child: Text('Delete Selected Reminders'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.allUsers.length,
            itemBuilder: (context, index) {
              final userData = widget.allUsers[index];
              final title = userData['event_name'];
              DateTime date = userData['date'].toDate();
              return Card(
                key: ValueKey(userData["doc_id"]),
                color: widget.selectedTitles.contains(title)
                    ? Colors.grey
                    : Color(0xff7E1636),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () => widget.onLongPress(title),
                  leading: Checkbox(
                    value: widget.selectedTitles.contains(title),
                    onChanged: (_) => widget.onLongPress(title),
                  ),
                  title: Text(
                    title != null ? title.toUpperCase() : '',
                    style: TextStyle(
                      color: widget.selectedTitles.contains(title)
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${_formatDate(date)} at ${userData["start_time"] != null ? userData["start_time"] : ''}',
                    style: TextStyle(
                      color: widget.selectedTitles.contains(title)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  List<Map<String, dynamic>> _convertSelectedTitlesToMapList(
      List<String> selectedTitles) {
    List<Map<String, dynamic>> selectedReminders = [];
    for (String title in selectedTitles) {
      Map<String, dynamic> reminder = widget.allUsers.firstWhere(
        (reminder) => reminder['event_name'] == title,
        orElse: () => Map<String, dynamic>(),
      );
      if (reminder.isNotEmpty) {
        selectedReminders.add(reminder);
      }
    }
    return selectedReminders;
  }
}
