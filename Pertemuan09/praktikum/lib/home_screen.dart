import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late SharedPreferences loginData;
  String username = '';

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username') ?? ''; //Mengatasi nilai null
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to Home'),
              const SizedBox(height: 20),
              Text(username.isNotEmpty
                  ? 'Hello, $username!'
                  : 'Loading...'), //Menangani username kosong
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loginData.setBool('login', true);
                  loginData.remove('username');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
