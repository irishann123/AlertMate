import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

/*class StartScreen extends StatelessWidget {
  StartScreen(this.list1, {super.key});*/
class StartScreen extends StatefulWidget {
  final void Function() list1;
  final void Function() list2;
  StartScreen(this.list1, this.list2, {Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // final void Function() list1;
  final List<String> buttonTitles = ['Custom Button', 'Button 1'];
  @override
  Widget build(context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            //  Expanded(
            //  child: ListView(
            // padding: EdgeInsets.symmetric(vertical: 20),
            // children: [
            Container(
              // Search bar
              padding: EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black, // Draw line under the search bar
                    width: 1.0,
                  ),
                ),
              ),
              child: TextField(
                // Search bar
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                // Adjust the value as needed
                gradient: LinearGradient(
                  colors: [
                    Color(0xff7E1636),
                    Color(0xff281537),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ), // Set container background color
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.list1();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 70),
                    foregroundColor: Color.fromARGB(255, 254, 253, 253),
                    backgroundColor: Color.fromARGB(0, 255, 255, 255)),
                // icon: const Icon(Icons.delete),
                label: Text(
                  'GROCERY SHOPPING LIST',
                  style: TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.delete),
              ),
            ),
            const SizedBox(height: 20),
// button 2
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                // Adjust the value as needed
                gradient: LinearGradient(
                  colors: [
                    Color(0xff7E1636),
                    Color(0xff281537),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ), // Set container background color
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.list2();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 70),
                    foregroundColor: Color.fromARGB(255, 253, 252, 252),
                    backgroundColor: Color.fromARGB(0, 246, 245, 245)),
                // icon: const Icon(Icons.delete),
                label: Text(
                  'STUDY LIST',
                  style: TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
