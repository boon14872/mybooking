// date select page

import 'package:flutter/material.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen({Key? key}) : super(key: key);

  @override
  _DateSelectScreenState createState() => _DateSelectScreenState();
}

// date only
class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกวันที่เดินทาง'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: const Text('เลือกวันที่เดินทาง'),
            ),
            if (_selectedDate != null)
              Text(
                'วันที่เดินทาง: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('ต่อไป'),
            ),
          ],
        ),
      ),
    );
  }
}
