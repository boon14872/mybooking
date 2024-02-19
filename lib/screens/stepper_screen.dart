// stepper screen will show step for progress transaction will show current step and next step

import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:mybooking/screens/dateSelect_screen.dart';
import 'package:mybooking/screens/payment_screen.dart';
import 'package:mybooking/screens/seatSelect_screen.dart';
import 'package:mybooking/screens/stationSelect_screen.dart';
import 'package:provider/provider.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({Key? key}) : super(key: key);

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int _currentStep = 0;
  final List<Step> _steps = <Step>[
    const Step(
      title: Text('เลือกสถานี'),
      content: StationSelectScreen(),
    ),
    const Step(
      title: Text('เลือกวันที่'),
      content: DateSelectScreen(),
    ),
    const Step(
      title: Text('เลือกที่นั่ง'),
      content: SeatSelectScreen(),
    ),
    const Step(
      title: Text('ชำระเงิน'),
      content: PaymentScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ticket = Provider.of<MyTicketProvider>(context);

    // validate step funtion
    bool validateStep() {
      switch (_currentStep) {
        case 0:
          return ticket.departureStation != null &&
              ticket.arrivalStation != null;
        case 1:
          return ticket.selectedDate != null &&
              ticket.selectedScheduleId != null;
        case 2:
          return ticket.selectedSeat != null;
        case 3:
          return ticket.selectedSeat != null;
        default:
          return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('จองการเดินทาง'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.fill,
            opacity: 0.2,
          ),
        ),
        child: Container(
          child: Stepper(
            controlsBuilder: (context, details) {
              return Row(
                children: <Widget>[
                  if (_currentStep != 0)
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 2,
                        shadowColor: Colors.grey,
                      ),
                      onPressed: () {
                        if (_currentStep > 0) {
                          setState(() {
                            _currentStep = _currentStep - 1;
                          });
                        }
                      },
                      child: const Text(
                        'ก่อนหน้า',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (_currentStep != _steps.length - 1)
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            validateStep() ? Colors.blue : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 2,
                        shadowColor: Colors.grey,
                      ),
                      onPressed: () {
                        if (_currentStep < _steps.length - 1) {
                          if (validateStep()) {
                            setState(() {
                              _currentStep = _currentStep + 1;
                            });
                          }
                        }
                      },
                      child: const Text(
                        'ถัดไป',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                ],
              );
            },
            // horizontal or vertical
            type: StepperType.horizontal,
            steps: _steps,
            currentStep: _currentStep,
            onStepTapped: null,
            stepIconBuilder: (stepIndex, stepState) {
              // make icon for each step with index and state
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: _currentStep == stepIndex
                      ? Colors.blue
                      : _currentStep > stepIndex
                          ? Colors.green
                          : Colors.grey,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/moon.webp'),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (stepIndex + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
