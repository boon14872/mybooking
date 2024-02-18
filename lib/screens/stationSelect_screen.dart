// station select for select departure and arrival station

import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';

List<Map<String, dynamic>> stationList = [
  {
    'id': 1,
    'name': 'Starbase Texas',
  },
  {
    'id': 2,
    'name': 'TH SpacePort Bangkok',
  },
  {
    'id': 3,
    'name': 'LC-39A Kennedy Space Center',
  },
  {
    'id': 4,
    'name': 'LC-40 Cape Canaveral Space Force Station',
  },
  {
    'id': 5,
    'name': 'SpaceX South Texas Launch Site',
  },
  {
    'id': 6,
    'name': 'SpaceX West Coast Launch Site',
  },
  {
    'id': 7,
    'name': 'SpaceX Florida Launch Site',
  },
  {
    'id': 8,
    'name': 'SpaceX Boca Chica Launch Site',
  }
];

List<Map<String, dynamic>> departureStationList = stationList;
List<Map<String, dynamic>> arrivalStationList = [
  {
    'id': 1,
    'name': 'Luna Base Station',
  },
  {
    'id': 2,
    'name': 'Luna Base Station 2',
  },
  {
    'id': 3,
    'name': 'Luna Gateways Station',
  },
  {
    'id': 4,
    'name': 'Luna Park Station',
  }
];

class StationSelectScreen extends StatefulWidget {
  const StationSelectScreen({Key? key}) : super(key: key);

  @override
  _StationSelectScreenState createState() => _StationSelectScreenState();
}

class _StationSelectScreenState extends State<StationSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<MyTicketProvider>(context);

    void onDepartureStationSelected(Map<String, dynamic> station) {
      ticketProvider.setStation(
        departure: station['name'],
      );
    }

    void onArrivalStationSelected(Map<String, dynamic> station) {
      ticketProvider.setStation(
        arrival: station['name'],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // station list
          StationListWidget(
            stationList: departureStationList,
            title: 'สถานีต้นทาง',
            onStationSelected: onDepartureStationSelected,
          ),

          // arrival station
          const SizedBox(height: 16),

          // station list
          StationListWidget(
            stationList: arrivalStationList,
            title: 'สถานีปลายทาง',
            onStationSelected: onArrivalStationSelected,
          ),
        ],
      ),
    );
  }
}

class StationListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> stationList;
  final String? title;
  final ValueChanged<Map<String, dynamic>> onStationSelected;

  const StationListWidget({
    Key? key,
    required this.stationList,
    this.title,
    required this.onStationSelected,
  }) : super(key: key);

  @override
  _StationListWidgetState createState() => _StationListWidgetState();
}

class _StationListWidgetState extends State<StationListWidget> {
  List<Map<String, dynamic>> filteredStationList = [];

  Map<String, dynamic> selectedStation = {};

  @override
  void initState() {
    super.initState();
    filteredStationList = widget.stationList; // Initialize with full list
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title ?? 'สถานี',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        // current station selected
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
              ),
            ],
            color: selectedStation['name'] != null
                ? Colors.tealAccent
                : Colors.white,
          ),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Text(
            selectedStation['name'] ?? 'เลือกสถานี',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color:
                  selectedStation['name'] != null ? Colors.white : Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // search station

        TextField(
          decoration: const InputDecoration(
            labelText: 'ค้นหาสถานี',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              filteredStationList = widget.stationList
                  .where((station) => station['name']
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                  .toList();
            });
          },
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          child: SingleChildScrollView(
            child: Column(
              children: filteredStationList.isNotEmpty
                  ? filteredStationList.map((station) {
                      return ListTile(
                        title: Text(station['name']),
                        onTap: () {
                          setState(() {
                            selectedStation = station;
                          });
                          widget.onStationSelected(
                              station); // Pass selected station
                        },
                      );
                    }).toList()
                  : [
                      const Text('ไม่พบสถานีที่ค้นหา'),
                    ],
            ),
          ),
        ),
      ],
    );
  }
}
