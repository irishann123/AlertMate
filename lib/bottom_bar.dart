import 'personaldet.dart';
import 'package:flutter/material.dart';
import 'container3.dart';
import 'home.dart';
import 'rem.dart';

class BottomBar extends StatelessWidget {
  final Widget centerWidget; // Add a parameter to accept the center widget

  const BottomBar({Key? key, required this.centerWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        //Color.fromRGBO(224, 249, 249, 0.929),
        body: Stack(children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  centerWidget,
                  //if (centerWidget != null) centerWidget!, // Use the passed center widget here
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_month,
                              color: Color(0xff281537), size: 30.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.notifications_active,
                              color: Color(0xff281537), size: 30.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllReminderPage()),
                            );
                          },
                        ),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                          icon: Icon(Icons.list_alt_rounded,
                              color: Color(0xff281537), size: 30.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GradientContainer()), // Replace YourListPage() with your actual list page widget
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.person_sharp,
                              color: Color(0xff281537), size: 30.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PersonalDetailsPage()), // Replace YourListPage() with your actual list page widget
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 232, 160, 181)
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = Colors.black // Adjust the color of the border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Increase the border width

    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);

    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    Path shadowPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height + 20)
      ..lineTo(size.width, size.height + 20)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
