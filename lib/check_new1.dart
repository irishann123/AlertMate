import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'background_scaffold.dart'; // Import BackgroundScaffold

class CheckList1 extends StatefulWidget {
  final String? buttonClicked;

  CheckList1({Key? key, this.buttonClicked}) : super(key: key);

  @override
  State<CheckList1> createState() => _CheckList1State();
}

class _CheckList1State extends State<CheckList1> {
  final _todoController = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold( // Use BackgroundScaffold here
      title: widget.buttonClicked?.toUpperCase() ?? 'CHECKLIST',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: Checkbox(
                    value: item['isDone'] ?? false,
                    onChanged: (newValue) {
                      _toggleItem(index, newValue);
                    },
                  ),
                  title: Text(item['text'] ?? ''),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0), // Adjust bottom padding
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Enter a new to-do item',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _addItem(_todoController.text);
                    _todoController.clear();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadItems() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('todo')
          .where('lists.name', isEqualTo: widget.buttonClicked)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final items = querySnapshot.docs.first['lists']['items'];
        if (items != null) {
          setState(() {
            _items = List<Map<String, dynamic>>.from(items);
          });
        }
      }
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  void _addItem(String text) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('todo')
          .where('lists.name', isEqualTo: widget.buttonClicked)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('todo').doc(docId).update({
          'lists.items': FieldValue.arrayUnion([
            {'text': text, 'isDone': false}
          ])
        });
        setState(() {
          _items.add({'text': text, 'isDone': false});
        });
      }
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  void _toggleItem(int index, bool? newValue) async {
    try {
      final updatedItems = List<Map<String, dynamic>>.from(_items);
      updatedItems[index]['isDone'] = newValue;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('todo')
          .where('lists.name', isEqualTo: widget.buttonClicked)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('todo').doc(docId).update({
          'lists.items': updatedItems,
        });
        setState(() {
          _items = updatedItems;
        });
      }
    } catch (e) {
      print('Error toggling item: $e');
    }
  }
}
