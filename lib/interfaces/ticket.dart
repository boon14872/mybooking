class Ticket {
  final int id;
  final String userId;
  final String seat;
  final String scheduleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status = 'pending';

  Ticket({
    required this.id,
    required this.userId,
    required this.seat,
    required this.scheduleId,
    required this.createdAt,
    required this.updatedAt,
  });
}
