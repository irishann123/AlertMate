import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.showBackButton = true, // Added showBackButton parameter
  }) : super(key: key);

  final String title;
  final Widget body;
  final bool showBackButton; // Define showBackButton parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(76, 168, 167, 167),
        title: Text(title),
        centerTitle: true,
        automaticallyImplyLeading:
            showBackButton, // Control back button visibility
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 236, 239, 255),
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Circular background
          // Circular background
          Positioned(
            right: -MediaQuery.of(context).size.width * 0.5,
            top: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Color.fromARGB(236, 69, 36, 95), // Adjust color as needed
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                        0.5), // Adjust shadow color and opacity as needed
                    spreadRadius: 7,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: -MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Color.fromARGB(194, 126, 22, 53), // Adjust color as needed
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                        0.5), // Adjust shadow color and opacity as needed
                    spreadRadius: 7,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          // Content
          body,
        ],
      ),
    );
  }
}
