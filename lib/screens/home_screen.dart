import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';

final menus = [
  {
    'title': 'จองรอบการเดินทาง',
    'icon': Icons.airplanemode_active_rounded,
    'color': Colors.blue,
  },
  {
    'title': 'การจองของฉัน',
    'icon': Icons.meeting_room,
    'color': Colors.green,
  },
  {
    'title': 'ประวัติการจอง',
    'icon': Icons.history,
    'color': Colors.orange,
  },
  {
    'title': 'ตั้งค่า',
    'icon': Icons.settings,
    'color': Colors.purple,
  },
];

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.jpg'),
            fit: BoxFit.fill,
            opacity: 0.5,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // have app logo and username detail with menu
                Row(
                  children: [
                    // app logo
                    Image.asset(
                      'images/logo.png',
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const SizedBox(width: 20.0),
                    // user detail
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สวัสดี, ${user.name}',
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.clip,
                            softWrap: true,
                            maxLines: 3,
                          ),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 75, 75, 75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // menu
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menus.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    return _buildMenu(context, menus[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, Map<String, dynamic> menu) {
    return InkWell(
      onTap: () {
        // navigate to menu
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: menu['color'],
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              menu['icon'],
              size: 50.0,
              color: Colors.white,
            ),
            const SizedBox(height: 10.0),
            Text(
              menu['title'],
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
