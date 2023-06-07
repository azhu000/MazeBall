import 'package:flutter/material.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/register_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.2),
              Text(
                "Welcome to MYAPP",
                style: TextStyle(
                    fontSize: (screenWidth * 0.1),
                    backgroundColor: Colors.amber),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.15),
              TextButton(
                style: TextButton.styleFrom(
                    fixedSize: Size(screenWidth * 0.25, screenWidth * 0.08),
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.black),
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
              SizedBox(height: screenHeight * 0.03),
              TextButton(
                style: TextButton.styleFrom(
                    fixedSize: Size(screenWidth * 0.25, screenWidth * 0.08),
                    // padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.black),
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
        ));
  }
}
