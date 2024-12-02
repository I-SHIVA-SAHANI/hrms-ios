import 'package:flutter/material.dart';
import 'package:hrms/homepage.dart';
import 'package:hrms/login.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF443ca9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  widthFactor: widthsize,
                  child: const Text(
                    "Attendance Management System",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
                const Center(
                  child: Image(
                    image: AssetImage(
                      'assets/images/hrm.png',
                    ),
                    width: 300,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 0, 191, 255),
                    ),
                    child: const Text(
                      "Employee Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  child: const Text("skip"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
