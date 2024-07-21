import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'background_scaffold.dart';
import 'newtask.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    // Navigate to a new page here
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewPage(selectedDay: selectedDay)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: 40,
        daysOfWeekHeight: 30,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 21, 24, 24),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        availableGestures: AvailableGestures.all,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2022, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        onDaySelected: _onDaySelected,
        calendarStyle: const CalendarStyle(
          weekendTextStyle: TextStyle(color: Color.fromARGB(255, 16, 18, 18)),
          todayDecoration: BoxDecoration(
            color: Color(0xff7E1636),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Color.fromARGB(187, 126, 22, 53),
            shape: BoxShape.circle,
          ),
        ),
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  final DateTime selectedDay;

  const NewPage({Key? key, required this.selectedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: 'Events for the Day',
      body: Stack(
        children: [
          // Positioning the white container over the calendar with a small portion visible
          Positioned(
            top: 0, // Adjust this value as needed
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: true, // Disable user interaction with the calendar
              child: CalendarWidget(),
            ),
          ),
          // White container with selected date text
          Positioned.fill(
            top: 250, // Adjust this value as needed
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color.fromARGB(255, 11, 11, 11),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Selected Date: $selectedDay'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewTaskPage(
                                selectedDay:
                                    selectedDay)), // Pass the selected date to the new task page
                      );
                    },
                    child: Text('Add New Task'),
                  ),
                  // Add additional text or widgets here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
