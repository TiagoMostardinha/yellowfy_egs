import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yellowfy/common/Handlers.dart';
import 'package:yellowfy/models/appointment.dart';

class BookingPage extends StatefulWidget {
  const BookingPage(
      {super.key, required this.announcement_id, required this.contractor_id});
  final String announcement_id;
  final String contractor_id;

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late DateTime _selectedDate;
  int _selectedHour = 0;

  Map<DateTime, List<int>> bookedSlots = {
    DateTime.now(): [10, 12, 15],
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchAppointments();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cannot select today's date or a past date."),
        ),
      );
      return;
    }
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  void _fetchAppointments() async {
    List<Appointment> appointments = await Handlers().handleGetAppointmentsCID();
    for (Appointment appointment in appointments) {
      if (appointment.announcement_id == widget.announcement_id &&
          appointment.contractor_id == widget.contractor_id) {
        DateTime appointmentDate = DateTime.parse(appointment.date_time);
        if (!bookedSlots.containsKey(appointmentDate)) {
          bookedSlots[appointmentDate] = [];
        }
        bookedSlots[appointmentDate]!.add(int.parse(appointment.duration));
      }
      print(appointment.announcement_id);
      if (kDebugMode) {
        print("appointment.contractor_id");
      }
    }
  }

  Future<void> _bookAppointment() async {
    if (_selectedDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Cannot book an appointment for today's date or a past date."),
        ),
      );
      return;
    }

    Appointment appointment = Appointment(
      widget.announcement_id,
      _selectedDate
          .toIso8601String(), // Use the selected date instead of current date
      'client_id',
      widget.contractor_id,
      _selectedHour.toString(),
    );
    try {
      await Handlers().handlePostAppointment(appointment);
      _showConfirmationDialog(context, 'Appointment booked successfully!');
    } catch (e) {
      print('Error booking appointment: $e');
      _showConfirmationDialog(context, 'Failed to book appointment.');
    }
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
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
      backgroundColor: Colors.black,
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
                  color: Colors.yellowAccent.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.yellowAccent,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.white),
                defaultTextStyle: const TextStyle(color: Colors.white),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
                weekendStyle: TextStyle(color: Colors.white),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: const TextStyle(color: Colors.white),
                formatButtonTextStyle: const TextStyle(color: Colors.white),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: _onDaySelected,
              availableCalendarFormats: const {CalendarFormat.month: ''},
              enabledDayPredicate: (day) {
                return day
                    .isAfter(DateTime.now().subtract(const Duration(days: 1)));
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Hours:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showAvailableHours(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                'View Available Hours for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selected Hour:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${_selectedHour.toString().padLeft(2, '0')}:00',
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Book Session',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvailableHours(BuildContext context) {
    List<int> availableHours = List.generate(24, (index) => index);

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
            'Available Hours for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: const TextStyle(color: Colors.black),
          ),
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
}
