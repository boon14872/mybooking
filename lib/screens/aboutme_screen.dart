// about me screen will show detail of the user

import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('เกี่ยวกับฉัน'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/bg.jpg'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.maxFinite,
              // height: MediaQuery.of(context).size.height, fit to the content
              height: MediaQuery.of(context).size.height * 0.3,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // avatar
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'ชื่อ: ${user.name}',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'อีเมลล์: ${user.email}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // create at
                  Text(
                    'สร้างเมื่อ: ${user.createdAt}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
