import 'package:flutter/material.dart';
import 'newtask2.dart'; // Import the NewTaskPage

class AddRem2 extends StatelessWidget {
  const AddRem2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.6,
      child: Container(
        width: 60, // Adjust the width and height to increase the size
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff281537), // Set the background color of the circle
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255), size: 30.0),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewTaskPage2()),
            );
          },
        ),
      ),
    );
  }
}
