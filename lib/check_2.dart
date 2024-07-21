import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;

  const MyCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
              if (widget.onChanged != null) {
                widget.onChanged!(isChecked);
              }
            });
          },
        ),
        Text(widget.label,
            style: TextStyle(
              fontSize: 23.0, // Adjust size of the label text
              color: Colors.white, // Adjust color of the label text
            )),
      ],
    );
  }
}

class Check2 extends StatefulWidget {
  const Check2({Key? key}) : super(key: key);

  @override
  State<Check2> createState() {
    return _Check2State();
  }
}

class _Check2State extends State<Check2> {
  bool graphicsChecked = false;
  bool englishChecked = false;
  bool mathsChecked = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 90.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* Text(
                        'Unchecked',
                        style: TextStyle(fontFamily: 'Licorice', fontSize: 42),
                      ),*/
                      const SizedBox(height: 20),
                      Container(
                        // Search bar
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors
                                  .black, // Draw line under the search bar
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TextField(
                          // Search bar
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            suffixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Color(0xff7E1636),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 3, 3, 3)
                                  .withOpacity(0.6),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10.0),
                        child: MyCheckbox(
                          value: graphicsChecked,
                          onChanged: (value) {
                            setState(() {
                              graphicsChecked = value!;
                            });
                          },
                          label: 'Graphics',
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Color(0xff7E1636),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 3, 3, 3)
                                  .withOpacity(0.6),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10.0),
                        child: MyCheckbox(
                          value: englishChecked,
                          onChanged: (value) {
                            setState(() {
                              englishChecked = value!;
                            });
                          },
                          label: 'English',
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Color(0xff7E1636),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 3, 3, 3)
                                  .withOpacity(0.6),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10.0),
                        child: MyCheckbox(
                          value: mathsChecked,
                          onChanged: (value) {
                            setState(() {
                              mathsChecked = value!;
                            });
                          },
                          label: 'Maths',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
