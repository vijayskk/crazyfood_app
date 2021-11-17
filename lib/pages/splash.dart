import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  checklogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    if (token == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      Response res = await post(
        Uri.parse(
            "https://crazyfood-server.vercel.app/api/items/getallcategories"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"token": token}),
      );
      if (res.statusCode == 200) {
        await sp.setString('cats', res.body);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F3E2),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset('assets/hamburger.gif'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                child: Column(
                  children: [
                    CupertinoActivityIndicator(
                      radius: 10,
                    ),
                    Text("Loading data...")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
