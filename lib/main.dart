import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybooking/provider.dart';
import 'package:mybooking/screens/dateSelect_screen.dart';
import 'package:mybooking/screens/home_screen.dart';
import 'package:mybooking/screens/login_screen.dart';
import 'package:mybooking/screens/seatSelect_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MyTicketProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.itimTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routes: Map<String, WidgetBuilder>.from(
        {
          '/login': (BuildContext context) => const LoginScreen(),
          '/home': (BuildContext context) => const MyHomePage(),
          '/dateSelect': (BuildContext context) => const DateSelectScreen(),
          // '/myBooking': (BuildContext context) => const MyBookingScreen(),
          // '/bookingHistory': (BuildContext context) => const BookingHistoryScreen(),
          // '/setting': (BuildContext context) => const SettingScreen(),
          '/seatSelect': (BuildContext context) => const SeatSelectScreen(),
        },
      ),
      initialRoute: '/login',
      home: const LoginScreen(),
    );
  }
}
