// provider for user data

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mybooking/interfaces/ticket.dart';
import 'package:mybooking/interfaces/user.dart';

class UserProvider with ChangeNotifier {
  late User _user = User(
    id: '1',
    name: 'testtesttesttest',
    email: 'test@test.com',
    password: 'test',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // api url
  final String _apiUrl = 'https://65c641e1e5b94dfca2e145a4.mockapi.io/v1';

  User get user => _user;

  // login user with id and password will check from api
  Future<User?> loginUser(String id, String password) async {
    // if id have @ remove it
    if (id.contains('@')) {
      id = id.split('@').first;
    }

    // get all users
    final response = await http.get(Uri.parse('$_apiUrl/users'));
    if (response.statusCode == 200) {
      final List<User> users = (json.decode(response.body) as List)
          .map((data) => User.fromJson(data))
          .toList();
      try {
        final User user = users.firstWhere((user) =>
            user.email.contains(
              id,
            ) &&
            user.password == password);
        _user = user;
        notifyListeners();
        return user;
      } catch (e) {
        throw Exception('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
      }
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อกับระบบได้');
    }
  }
}

class TicketProvider with ChangeNotifier {
  late List<Ticket> _tickets = [];
  DateTime? _selectedDate;
  String status = 'pending';
  String? _selectedSeat;
  String? _selectedScheduleId;

  // get set
  List<Ticket> get tickets => _tickets;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedSeat => _selectedSeat;
  String? get selectedScheduleId => _selectedScheduleId;

  // set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // set selected seat
  void setSelectedSeat(String seat) {
    _selectedSeat = seat;
    notifyListeners();
  }

  // set selected schedule id
  void setSelectedScheduleId(String scheduleId) {
    _selectedScheduleId = scheduleId;
    notifyListeners();
  }

  // list of schedule for selected schedule it will generate from selected date
  List<Map<String, dynamic>> get schedules {
    final List<Map<String, dynamic>> _schedules = [
      {
        'id': '1',
        'time': '09:00',
        'price': 3000,
        'seats': ['A1', 'A2', 'A3', 'A4', 'A5'],
      },
      {
        'id': '2',
        'time': '13:00',
        'price': 3299,
        'seats': ['A1', 'A2', 'A3', 'A4', 'A5'],
      },
      {
        'id': '3',
        'time': '17:00',
        'price': 3990,
        'seats': ['A1', 'A2', 'A3', 'A4', 'A5'],
      },
      {
        'id': '4',
        'time': '21:00',
        'price': 3890,
        'seats': ['A1', 'A2', 'A3', 'A4', 'A5'],
      },
    ];
    return _schedules;
  }

  // book ticket
  Future<Ticket> bookTicket(String userId) async {
    final Ticket ticket = Ticket(
      id: 1,
      userId: userId,
      seat: _selectedSeat!,
      scheduleId: _selectedScheduleId!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _tickets.add(ticket);
    notifyListeners();
    return ticket;
  }
}
