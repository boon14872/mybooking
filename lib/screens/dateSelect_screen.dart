import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen({Key? key}) : super(key: key);

  @override
  _DateSelectScreenState createState() => _DateSelectScreenState();
}

class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? _selectedDate;
  String? _selectedSchedule; // Add a variable to store the selected schedule

  List<Map<String, dynamic>> _schedules =
      []; // Replace with your actual schedule data

  @override
  Widget build(BuildContext context) {
    final ticket = Provider.of<MyTicketProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: SingleChildScrollView(
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: _selectedDate ?? DateTime.now(),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _fetchSchedulesForDate(selectedDay);
                      ticket.setSelectedDate(selectedDay);
                    });
                  },
                  currentDay: _selectedDate ?? DateTime.now(),
                  // Add a custom header
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'เลือกรอบการเดินทาง',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_schedules.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: Text(
                    _selectedDate != null
                        ? 'ไม่มีรอบการเดินทางในวันที่เลือก'
                        : 'กรุณาเลือกวันที่เดินทาง',
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.4,
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _schedules.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final schedule = _schedules[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSchedule = schedule['time'];
                              ticket.setSelectedScheduleId(schedule['id']);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _selectedSchedule == schedule['time']
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  schedule['time'],
                                  style: TextStyle(
                                    color: _selectedSchedule == schedule['time']
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  '${schedule['price']} บาท',
                                  style: TextStyle(
                                    color: _selectedSchedule == schedule['time']
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            // const SizedBox(height: 20),
            // _selectedSchedule != null
            //     ? ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 16.0, horizontal: 24.0),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8.0)),
            //           backgroundColor: Colors.blue[300],
            //           surfaceTintColor: Colors.blue[300],
            //         ),
            //         onPressed: () {
            //           if (_selectedDate != null && _selectedSchedule != null) {
            //             _setSelectedDateAndSchedule();
            //             Navigator.pushNamed(context, '/seatSelect');
            //           }
            //         },
            //         child: const Text(
            //           'ต่อไป',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       )
            //     : const ElevatedButton(
            //         onPressed: null,
            //         child: Text(
            //           'ต่อไป',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
          ],
        ),
      ),
    );
  }

  void _fetchSchedulesForDate(DateTime selectedDate) {
    final ticket = Provider.of<MyTicketProvider>(context, listen: false);
    setState(() {
      // _schedules = ticket.schedules; if odd day will have 4 schedules else 5 schedules

      // Add a condition to check if the selected date is an odd day
      if (selectedDate.day.isOdd) {
        _schedules = ticket.schedules.sublist(1);
      } else {
        // _schedules = ticket.schedules; remove last schedule
        _schedules = ticket.schedules.sublist(0, 4);
      }
    });
  }
}
