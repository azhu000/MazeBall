import 'package:flutter/material.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/register_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Welcome to MYAPP",
            style: TextStyle(fontSize: (screenWidth * 0.1)),
            textAlign: TextAlign.center,
          ),
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(10)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginPage(title: 'LoginPage');
              }));
            },
            child: Text(
              'Login',
              style: TextStyle(fontSize: (screenWidth * 0.05)),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(10)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const RegisterPage(title: 'RegisterPage');
              }));
            },
            child: Text('Register',
                style: TextStyle(fontSize: (screenWidth * 0.05))),
          )
        ],
      ),
    );
  }
}
