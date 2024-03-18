import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late DateTime _selectedDate;
  int _selectedHour = 8; // Default hour for booking
  int _selectedDuration = 1; // Default duration in hours

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
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
                  'Your session has been booked for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} at $_selectedHour:00 for $_selectedDuration hours',
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
            const Text(
              'Select Date:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Hour:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: _selectedHour,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedHour = newValue;
                  });
                }
              },
              items: List.generate(
                24,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text('${index.toString().padLeft(2, '0')}:00'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Duration:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: _selectedDuration,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedDuration = newValue;
                  });
                }
              },
              items: List.generate(
                24,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1} hour${index > 0 ? 's' : ''}'),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle booking logic here
                  _showConfirmationDialog(context); // Show confirmation dialog
                },
                child: const Text('Book Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
