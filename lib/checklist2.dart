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
          visualDensity: VisualDensity.standard.copyWith(
              horizontal: 3.0, vertical: 3.0), // Increase checkbox size
        ),
        Text(widget.label),
      ],
    );
  }
}

class CheckList2 extends StatefulWidget {
  const CheckList2({Key? key}) : super(key: key);

  @override
  State<CheckList2> createState() {
    return _CheckList2State();
  }
}

class _CheckList2State extends State<CheckList2> {
  late bool englishChecked;
  late bool mathsChecked;
  late bool graphicsChecked;

  @override
  void initState() {
    super.initState();
    englishChecked = false;
    mathsChecked = false;
    graphicsChecked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors
                                .black, // Draw line under "Unchecked" text
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Text('Unchecked',
                          style:
                              TextStyle(fontFamily: 'Licorice', fontSize: 42)),
                    ),
                    const SizedBox(height: 30),*/
                    //  const SizedBox(height: 20), // Add spacing
                    SingleChildScrollView(
                      child: Column(
                        children: [
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
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          buildMyCheckbox('English', englishChecked, (value) {
                            setState(() {
                              englishChecked = value;
                              if (value) {
                                mathsChecked = false;
                                graphicsChecked = false;
                              }
                            });
                          }),
                          buildMyCheckbox('Maths', mathsChecked, (value) {
                            setState(() {
                              mathsChecked = value;
                              if (value) {
                                englishChecked = false;
                                graphicsChecked = false;
                              }
                            });
                          }),
                          /*buildMyCheckbox(
                            'Graphics',
                            graphicsChecked,
                            (value) {
                              setState(() {
                                graphicsChecked = value;
                                if (value) {
                                  englishChecked = false;
                                  mathsChecked = false;
                                }
                              });
                            },
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMyCheckbox(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: MyCheckbox(
        value: value,
        onChanged: onChanged,
        label: label,
      ),
    );
  }
}
