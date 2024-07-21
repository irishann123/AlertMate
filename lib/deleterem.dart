import 'package:flutter/material.dart';

class DeleteRem extends StatefulWidget {
  final List<Map<String, dynamic>> allUsers;
  final Function(List<Map<String, dynamic>>) onDelete;

  const DeleteRem({
    Key? key,
    required this.allUsers,
    required this.onDelete,
  }) : super(key: key);

  @override
  _DeleteRemState createState() => _DeleteRemState();
}

class _DeleteRemState extends State<DeleteRem> {
  Set<int> _selectedItems = {};

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems.add(id);
      }
    });
  }

  void _deleteSelectedItems() {
    List<Map<String, dynamic>> updatedList = List.from(widget.allUsers);
    updatedList.removeWhere((user) => _selectedItems.contains(user["id"]));
    widget.onDelete(updatedList);
    setState(() {
      _selectedItems.clear();
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _selectedItems.isNotEmpty ? _deleteSelectedItems : null,
          child: Text('Delete Selected Reminders'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.allUsers.length,
            itemBuilder: (context, index) {
              final userData = widget.allUsers[index];
              // Convert timestamp to DateTime
              DateTime date = userData['date'].toDate();
              return Card(
                key: ValueKey(userData["id"]),
                color: _selectedItems.contains(userData["id"])
                    ? Colors.grey
                    : Color(0xff7E1636),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () => _toggleSelection(userData["id"]),
                  leading: Checkbox(
                    value: _selectedItems.contains(userData["id"]),
                    onChanged: (_) => _toggleSelection(userData["id"]),
                  ),
                  title: Text(
                    userData['event_name'] != null ? userData['event_name'].toUpperCase() : '',
                    style: TextStyle(
                      color: _selectedItems.contains(userData["id"])
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold, // Making text bold
                    ),
                  ),
                  subtitle: Text(
                    '${_formatDate(date)} at ${userData["start_time"] != null ? userData["start_time"] : ''}',
                    style: TextStyle(
                      color: _selectedItems.contains(userData["id"])
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
}
