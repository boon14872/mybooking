import 'package:flutter/material.dart';
import 'package:mybooking/interfaces/ticket.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isPayment = false;

  @override
  Widget build(BuildContext context) {
    final ticket = Provider.of<MyTicketProvider>(context);
    final user = Provider.of<UserProvider>(context);

    bool isTicketValid = ticket.departureStation != null &&
        ticket.arrivalStation != null &&
        ticket.selectedDate != null &&
        ticket.selectedScheduleId != null &&
        ticket.selectedSeat != null;

    if (!isTicketValid) {
      return const Center(
        child: Text('กรุณาเลือกข้อมูลการเดินทาง'),
      );
    }

    bool isUserValid = user.user.id != null;

    if (!isUserValid) {
      return const Center(
        child: Text('กรุณาเข้าสู่ระบบ'),
      );
    }

    Ticket ticketData = Ticket(
      id: ticket.tickets.length + 1,
      userId: user.user.id,
      seat: ticket.selectedSeat,
      scheduleId: ticket.selectedScheduleId ?? "1",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      departureStation: ticket.departureStation ?? "Not selected",
      arrivalStation: ticket.arrivalStation ?? "Not selected",
    );

    ticketData.status = isPayment ? 'paid' : 'pending';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'รายละเอียดการจอง',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildTicketDetails(ticket),
          Center(
            child: Column(children: [
              _buildQrCode(ticket),
              const SizedBox(height: 16),
              const Text(
                'สถานะการชำระเงิน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ticketData.status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isPayment ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!isPayment) {
                    setState(() {
                      isPayment = true;
                      ticketData.status = 'paid';
                    });
                  } else {
                    ticket.bookTicket(ticketData);
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPayment ? Colors.grey : Colors.blueAccent,
                ),
                child: Text(
                  isPayment ? 'ตกลง' : 'ยืนยันการชำระเงิน',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPayment ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails(MyTicketProvider ticket) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Departure'),
                    Text(
                      ticket.departureStation ?? 'Not selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Arrival'),
                    Text(
                      ticket.arrivalStation ?? 'Not selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date'),
                    Text(
                      ticket.selectedDate != null
                          ? '${ticket.selectedDate?.day}/${ticket.selectedDate?.month}/${ticket.selectedDate?.year}'
                          : 'Not selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Time'),
                    Text(
                      ticket.schedules.firstWhere((e) =>
                              e['id'] == ticket.selectedScheduleId)['time'] ??
                          'Not selected',
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Seats'),
                    Text(
                      ticket.selectedSeat
                              ?.map((e) => 'แถว ${e.rowI}, ที่นัง ${e.colI}')
                              .join('\n') ??
                          'Not selected',
                    )
                  ],
                ),
              ),

              // Add this line
              if (ticket.selectedSeat != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Price'),
                      Text(
                        '${(ticket.selectedSeat?.length ?? 0) * ticket.schedules.firstWhere((e) => e['id'] == ticket.selectedScheduleId)['price']} บาท',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCode(MyTicketProvider ticket) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text('Scan QR Code to make payment'),
        const SizedBox(height: 8),
        QrImageView(
          data: _generateQRData(ticket),
          size: 200,
        ),
      ],
    );
  }

  String _generateQRData(MyTicketProvider ticket) {
    return 'Departure: ${ticket.departureStation}\n'
        'Arrival: ${ticket.arrivalStation}\n'
        'Date: ${ticket.selectedDate?.day}/${ticket.selectedDate?.month}/${ticket.selectedDate?.year}\n'
        'Time: ${ticket.selectedScheduleId}\n'
        'Seats: ${ticket.selectedSeat?.map((e) => 'Row ${e.rowI}, Seat ${e.colI}').join(', ')}';
  }

  String _paymentButtonLabel(Ticket ticket) {
    return ticket.status == 'paid' ? 'ชำระเงินแล้ว' : 'รอการชำระเงิน';
  }
}
