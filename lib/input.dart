import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({
    Key? key,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 213, 213, 213),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hint, // Display hint text
                      hintStyle: TextStyle(color: Colors.grey), // Hint text style
                      border: InputBorder.none, // Remove border
                      contentPadding: EdgeInsets.symmetric(horizontal: 16), // Add padding
                    ),
                  ),
                ),
                if (widget != null) widget!, // Display the widget if provided
              ],
            ),
          )
        ],
      ),
    );
  }
}