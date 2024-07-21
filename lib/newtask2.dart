import 'package:flutter/material.dart';
import 'background_scaffold.dart';
import 'firestore.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class NewTaskPage2 extends StatefulWidget {
  const NewTaskPage2({Key? key}) : super(key: key);

  @override
  _NewTaskPage2State createState() => _NewTaskPage2State();
}

class _NewTaskPage2State extends State<NewTaskPage2> {
  late DateTime _selectedDate = DateTime.now(); // Modified line
  bool isImportant = false;
  bool isEmergency = false;

  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  TextEditingController _repeatAlarmController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  final _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  void _addNewTask() async {
    try {
      // Parse selected time from TimeOfDay objects
      TimeOfDay startTime = TimeOfDay(
          hour: _selectedStartTime.hour, minute: _selectedStartTime.minute);
      TimeOfDay endTime = TimeOfDay(
          hour: _selectedEndTime.hour, minute: _selectedEndTime.minute);

      // Get the current user's email from FirebaseAuth
      String userEmail = _auth.currentUser!.email!;

      await _firestoreService.addReminder(
        userId: 'USER_ID',
        eventName: _eventNameController.text,
        eventDescription: _eventDescriptionController.text,
        date: _selectedDate, // Modified line
        startTime: startTime,
        endTime: endTime,
        repeatInterval: _repeatAlarmController.text,
        emergencyContact: isEmergency ? 'true' : 'false',
        userEmail: userEmail, // Pass the userEmail to FirestoreService
        isImportant: isImportant,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New task added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add new task: $e')),
      );
    }
  }

  Future<void> _selectDateForTask(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2015, 8),
    lastDate: DateTime(2101),
  );
  if (pickedDate != null) {
    setState(() {
      _selectedDate = pickedDate;
      // Update the text of the date TextField with the selected date
      _startDateController.text = DateFormat('yyyy/MM/dd').format(_selectedDate);
    });
  }
}


  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedStartTime = pickedTime;
        _startTimeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedEndTime = pickedTime;
        _endTimeController.text = pickedTime.format(context);
      });
    }
  }

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  String? _selectedRepeatOption;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: '',
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 175, left: 0, right: 0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isImportant = !isImportant;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            isImportant ? Icons.star : Icons.star_border,
                            size: 30,
                            color: isImportant ? Colors.yellow : Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Important',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                    onTapDown: (_) => _listen1(),
                    onTapUp: (_) => _stopListening(),
                    onTapCancel: () => _stopListening(),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(236, 69, 36, 95),
                      ),
                      child: Icon(
                        Icons.mic_outlined,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                    SizedBox(width: 25),
                    Expanded(
                      child: TextField(
                        controller: _eventNameController,
                        decoration: InputDecoration(
                          hintText: 'Event Name*',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _eventDescriptionController,
                        decoration: InputDecoration(
                          hintText: 'Type Note Here...',
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    GestureDetector(
                    onTapDown: (_) => _listen2(),
                    onTapUp: (_) => _stopListening(),
                    onTapCancel: () => _stopListening(),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(236, 69, 36, 95),
                      ),
                      child: Icon(
                        Icons.mic_outlined,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  ],
                ),
                 SizedBox(height: 5),
                // DatePicker for selecting date
                TextField(
                controller: _startDateController,
                readOnly: true,
                onTap: () => _selectDateForTask(context),
                decoration: InputDecoration(
                  hintText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () => _selectDateForTask(context),
                  ),
                ),
              ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startTimeController,
                        readOnly: true,
                        onTap: () => _selectStartTime(context),
                        decoration: InputDecoration(
                          hintText: 'Start',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: () => _selectStartTime(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: TextField(
                        controller: _endTimeController,
                        readOnly: true,
                        onTap: () => _selectEndTime(context),
                        decoration: InputDecoration(
                          hintText: 'End',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: () => _selectEndTime(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                value: _selectedRepeatOption,
                onChanged: (newValue) {
                  setState(() {
                    _selectedRepeatOption = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Daily',
                    child: Text('Daily'),
                  ),
                  DropdownMenuItem(
                    value: 'Weekly',
                    child: Text('Weekly'),
                  ),
                  DropdownMenuItem(
                    value: 'Monthly',
                    child: Text('Monthly'),
                  ),
                  // Add more DropdownMenuItem for additional options
                ],
                decoration: InputDecoration(
                  hintText: 'Repeat Alarm',
                ),
              ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Emergency Contact',
                      style: TextStyle(
                        color: Color.fromARGB(236, 69, 36, 95),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    Switch(
                      activeColor: Color.fromARGB(236, 69, 36, 95),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Color.fromARGB(235, 106, 66, 137),
                      value: isEmergency,
                      onChanged: (value) {
                        setState(() {
                          isEmergency = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 50),
                        backgroundColor: const Color.fromARGB(236, 69, 36, 95),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _addNewTask,
                      child: Text('Add New Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _listen1() async {
  if (!_isListening) {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
          if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
            print(_confidence);
          }
          _eventNameController.text = _text; // Set captured text to the TextField
        }),
      );
    }
  } else {
    setState(() => _isListening = false);
    _speech.stop();
  }
}
void _listen2() async {
  if (!_isListening) {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
          if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
          }
          _eventDescriptionController.text = _text; // Set captured text to the TextField
        }),
      );
    }
  } else {
    setState(() => _isListening = false);
    _speech.stop();
  }
}
void _stopListening() {
  if (_isListening) {
    setState(() => _isListening = false);
    _speech.stop();
  }
}
}