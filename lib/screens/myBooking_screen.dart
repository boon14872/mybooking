// list of my booking screen

import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticket = Provider.of<MyTicketProvider>(context)
        .tickets
        .where((element) =>
            element.status.toLowerCase() == 'paid' ||
            element.status.toLowerCase() == 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('การจองของฉัน'),
      ),
      body: Container(
          // if there is no ticket
          child: ticket.isEmpty
              ? const Center(
                  child: Text('ไม่มีข้อมูลการจองตั๋วเดินทาง'),
                )
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  // ListView.builder(
                  //   itemCount: ticket.length,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(

                  //       title: Text(
                  //           '${ticket[index].departureStation} - ${ticket[index].arrivalStation}'),
                  //       subtitle: Text(
                  //           'Status: ${ticket[index].status} - Seat: ${ticket[index].seat?.map((e) => 'แถว ${e.rowI} ที่ ${e.colI}').join(', ') ?? 'Not selected'}'),
                  //     );
                  //   },
                  // ),
                  // use column instead of listview and bueatifullist tile to show the ticket based on the status will set background color
                  // to green if the status is paid and red if the status is pending
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: ticket.length,
                        itemBuilder: (context, index) {
                          return Card(
                            semanticContainer: true,
                            shadowColor: Colors.black,
                            elevation: 3,
                            color: ticket[index].status.toLowerCase() == 'paid'
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            child: ListTile(
                              title: Text(
                                '${ticket[index].departureStation} - ${ticket[index].arrivalStation}',
                                style: TextStyle(
                                  color: ticket[index].status.toLowerCase() ==
                                          'paid'
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                  'Status: ${ticket[index].status} - Seat: ${ticket[index].seat?.map((e) => 'แถว ${e.rowI} ที่ ${e.colI}').join(', ') ?? 'Not selected'}'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )),
    );
  }
}
