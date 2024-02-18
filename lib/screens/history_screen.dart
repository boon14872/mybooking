// like myBooking screen but this screen will show the history of the ticket have status used and canceled

import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticket = Provider.of<MyTicketProvider>(context)
        .tickets
        .where((element) =>
            element.status.toLowerCase() == 'used' ||
            element.status.toLowerCase() == 'canceled')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการเดินทาง'),
      ),
      body: Container(
        child: ticket.isEmpty
            ? const Center(
                child: Text('ไม่มีข้อมูลการเดินทางที่เสร็จสิ้นและถูกยกเลิก'),
              )
            : Container(
                padding: const EdgeInsets.all(16.0),
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
                          color: ticket[index].status.toLowerCase() == 'used'
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          child: ListTile(
                            title: Text(
                              '${ticket[index].departureStation} - ${ticket[index].arrivalStation}',
                              style: TextStyle(
                                color:
                                    ticket[index].status.toLowerCase() == 'used'
                                        ? Colors.black
                                        : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              'Status: ${ticket[index].status} - Seat: ${ticket[index].seat?.map((e) => 'แถว ${e.rowI} ที่ ${e.colI}').join(', ') ?? 'Not selected'}',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
