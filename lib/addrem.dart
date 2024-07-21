import 'package:flutter/material.dart';
import 'newtask.dart'; // Import the NewTaskPage

class AddRem extends StatelessWidget {
  const AddRem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.6,
      child: GestureDetector(
        onTap: () {
          // Navigate to the NewTaskPage on tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskPage(selectedDay: DateTime.now()),
            ),
          );
        },
        child: FloatingActionButton(
          backgroundColor: Color(0xff281537),
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: 30.0), // Use the plus icon
          elevation: 0.1,
          onPressed: () {}, // Leave it empty since navigation is handled above
        ),
      ),
    );
  }
}
