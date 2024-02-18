// provider for user data

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mybooking/interfaces/ticket.dart';
import 'package:mybooking/interfaces/user.dart';
import 'package:mybooking/screens/seatSelect_screen.dart';

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

class MyTicketProvider with ChangeNotifier {
  late final List<Ticket> _tickets = [
    Ticket(
      id: 1,
      userId: '1',
      scheduleId: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      departureStation: 'Bangkok',
      arrivalStation: 'Chiang Mai',
      status: 'paid',
      seat: <SeatNumber>{
        const SeatNumber(
          rowI: 1,
          colI: 1,
        ),
        const SeatNumber(
          rowI: 1,
          colI: 2,
        ),
      },
    ),
    Ticket(
      id: 2,
      userId: '1',
      scheduleId: '2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      departureStation: 'Spacex Boca Chica TX',
      arrivalStation: 'Luna Gateway Station',
      status: 'pending',
      seat: <SeatNumber>{
        const SeatNumber(
          rowI: 1,
          colI: 3,
        ),
        const SeatNumber(
          rowI: 1,
          colI: 4,
        ),
      },
    ),
    Ticket(
      id: 3,
      userId: '1',
      scheduleId: '3',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      departureStation: 'Spacex Boca Chica TX',
      arrivalStation: 'Luna Gateway Station',
      status: 'paid',
      seat: <SeatNumber>{
        const SeatNumber(
          rowI: 1,
          colI: 5,
        ),
        const SeatNumber(
          rowI: 1,
          colI: 6,
        ),
      },
    ),

    // used ticket
    Ticket(
      id: 4,
      userId: '1',
      scheduleId: '4',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      departureStation: 'Spacex Boca Chica TX',
      arrivalStation: 'Luna Gateway Station',
      status: 'used',
      seat: <SeatNumber>{
        const SeatNumber(
          rowI: 1,
          colI: 7,
        ),
        const SeatNumber(
          rowI: 1,
          colI: 8,
        ),
      },
    ),

    // canceled ticket
    Ticket(
      id: 5,
      userId: '1',
      scheduleId: '5',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      departureStation: 'Spacex Boca Chica TX',
      arrivalStation: 'Luna Gateway Station',
      status: 'canceled',
      seat: <SeatNumber>{
        const SeatNumber(
          rowI: 1,
          colI: 9,
        ),
        const SeatNumber(
          rowI: 1,
          colI: 10,
        ),
      },
    ),
  ];
  DateTime? _selectedDate;
  String status = 'pending';
  Set<SeatNumber>? _selectedSeat;
  String? _selectedScheduleId;
  String? _departureStation;
  String? _arrivalStation;

  // get set
  List<Ticket> get tickets => _tickets;
  DateTime? get selectedDate => _selectedDate;
  Set<SeatNumber>? get selectedSeat => _selectedSeat;
  String? get selectedScheduleId => _selectedScheduleId;
  String? get departureStation => _departureStation;
  String? get arrivalStation => _arrivalStation;

  // set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // set selected seat
  void setSelectedSeat(Set<SeatNumber> seat) {
    _selectedSeat = seat;
    notifyListeners();
  }

  // set selected schedule id
  void setSelectedScheduleId(String scheduleId) {
    _selectedScheduleId = scheduleId;
    notifyListeners();
  }

  // set selected station
  void setStation({String? departure, String? arrival}) {
    if (departure != null) {
      _departureStation = departure;
    }
    if (arrival != null) {
      _arrivalStation = arrival;
    }

    notifyListeners();
  }

  // list of schedule for selected schedule it will generate from selected date
  List<Map<String, dynamic>> get schedules {
    final List<Map<String, dynamic>> schedules = [
      {
        'id': '1',
        'time': '09:00',
        'price': 3000,
      },
      {
        'id': '2',
        'time': '13:00',
        'price': 3299,
      },
      {
        'id': '3',
        'time': '17:00',
        'price': 3990,
      },
      {
        'id': '4',
        'time': '21:00',
        'price': 3890,
      },
      {
        'id': '5',
        'time': '23:00',
        'price': 3990,
      },
    ];
    return schedules;
  }

  // book ticket
  Ticket bookTicket(Ticket tick) {
    _tickets.add(tick);
    // reset all
    _selectedDate = null;
    _selectedSeat = null;
    _selectedScheduleId = null;
    _departureStation = null;
    _arrivalStation = null;

    notifyListeners();
    return tick;
  }
}
