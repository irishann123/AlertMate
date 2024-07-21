import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'check_new1.dart'; // Import the CheckList1 widget

class Comp extends StatefulWidget {
  final void Function() list2;

  const Comp(this.list2, {Key? key}) : super(key: key);

  @override
  State<Comp> createState() => _CompState();
}

class _CompState extends State<Comp> {
  final List<String> buttonTitles = [];
  final TextEditingController _buttonController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String? buttonClicked;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadTodoLists();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 10, right: 10, bottom: 20),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild when text changes
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20), // Add bottom padding here
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            height: 300, // Height of each container
                            child: ListView.builder(
                              itemCount: buttonTitles.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckList1(buttonClicked: buttonTitles[index]),
                                      ),
                                    );
                                  },
                                  child: Material(
                                    elevation: 4, // Adjust the elevation as needed
                                    shadowColor: Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xff7E1636), // Change color as needed
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          buttonTitles[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255), // Change background color here
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _buttonController,
                      decoration: InputDecoration(
                        hintText: 'Enter a new button title',
                        border: OutlineInputBorder(),
                        filled: true, // Fill the background
                        fillColor: Colors.white, // Change background color here
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await _addTodoList(_buttonController.text);
                        _buttonController.clear();
                      },
                      child: Text('Add Button'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _filteredList(String query) {
    return buttonTitles.where((title) {
      return title.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _addTodoList(String title) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String email = user.email ?? "";

        await _firestore.collection('todo').add({
          'email': email,
          'lists': {
            'name': title,
            'items': {},
          },
        });

        setState(() {
          buttonTitles.add(title);
        });
      }
    } catch (e) {
      print('Failed to add todo list: $e');
    }
  }

  Future<void> _loadTodoLists() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String email = user.email ?? "";
        QuerySnapshot todoSnapshot = await _firestore
            .collection('todo')
            .where('email', isEqualTo: email)
            .get();
        List<String> titles = todoSnapshot.docs.map<String>((doc) {
          return doc['lists']['name'] as String;
        }).toList();
        setState(() {
          buttonTitles.addAll(titles);
        });
      }
    } catch (e) {
      print('Failed to load todo lists: $e');
    }
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Comp(() {}),
  ));
}
