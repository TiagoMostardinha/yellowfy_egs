import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yellowfy/common/Handlers.dart';
import 'package:yellowfy/models/appointment.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.announcement_id});
  final String announcement_id;

  @override
  // ignore: library_private_types_in_public_api
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late DateTime _selectedDate;
  int _selectedHour = 0;

  // Dummy list of booked slots for demonstration
  Map<DateTime, List<int>> bookedSlots = {
    DateTime.now(): [10, 12, 15], // Example: Already booked hours for today
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Session'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: _onDaySelected,
              availableCalendarFormats: {CalendarFormat.month: ''},
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Hours:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showAvailableHours(context),
              child: Text(
                  'View Available Hours for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selected Hour:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('${_selectedHour.toString().padLeft(2, '0')}:00'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle booking logic here
                  _showConfirmationDialog(context); // Show confirmation dialog
                  // print announvement id
                  print('ola');
                },
                child: const Text('Book Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvailableHours(BuildContext context) {
    List<int> availableHours = List.generate(24, (index) => index + 1);

    // If booked slots exist for the selected date, remove them from available hours
    if (bookedSlots.containsKey(_selectedDate)) {
      availableHours = availableHours
          .where((hour) => !bookedSlots[_selectedDate]!.contains(hour))
          .toList();
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Available Hours for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableHours.map((hour) {
                return ListTile(
                  title: Text('${hour.toString().padLeft(2, '0')}:00'),
                  onTap: () {
                    setState(() {
                      _selectedHour = hour;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Your session has been booked for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} at $_selectedHour:00 with the ${widget.announcement_id} announcement.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
