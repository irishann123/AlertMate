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

class CheckList1 extends StatefulWidget {
  const CheckList1({Key? key}) : super(key: key);

  @override
  State<CheckList1> createState() {
    return _CheckList1State();
  }
}

class _CheckList1State extends State<CheckList1> {
  bool milkChecked = false;
  bool eggsChecked = false;
  bool appleChecked = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 90.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*  Text(
                        'UNCHECKED',
                        style: TextStyle(fontSize: 32),
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
                          value: milkChecked,
                          onChanged: (value) {
                            setState(() {
                              milkChecked = value!;
                            });
                          },
                          label: 'Milk',
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
                          value: eggsChecked,
                          onChanged: (value) {
                            setState(() {
                              eggsChecked = value!;
                            });
                          },
                          label: 'Eggs',
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
                          value: appleChecked,
                          onChanged: (value) {
                            setState(() {
                              appleChecked = value!;
                            });
                          },
                          label: 'Apple',
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
