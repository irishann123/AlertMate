import 'package:flutter/material.dart';

class Back2Scaffold extends StatelessWidget {
  const Back2Scaffold({
    Key? key,
    required this.body, // Added showBackButton parameter
  }) : super(key: key);

  final Widget body; // Define showBackButton parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
             Color(0xffB81736),
              Color(0xff281537),
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}