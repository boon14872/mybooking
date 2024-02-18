import 'package:mybooking/screens/seatSelect_screen.dart';

class Ticket {
  final int id;
  final String userId;
  final Set<SeatNumber>? seat;
  final String scheduleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  String status = 'pending';
  final String departureStation;
  final String arrivalStation;
  Ticket({
    required this.id,
    required this.userId,
    required this.seat,
    required this.scheduleId,
    required this.createdAt,
    required this.updatedAt,
    required this.departureStation,
    required this.arrivalStation,
    this.status = 'pending',
  });
}
