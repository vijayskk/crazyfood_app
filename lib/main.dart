import 'package:crazyfood_app/pages/addressmanager.dart';
import 'package:crazyfood_app/pages/checkout.dart';
import 'package:crazyfood_app/pages/details.dart';
import 'package:crazyfood_app/pages/home.dart';
import 'package:crazyfood_app/pages/login.dart';
import 'package:crazyfood_app/pages/orders.dart';
import 'package:crazyfood_app/pages/register.dart';
import 'package:crazyfood_app/pages/splash.dart';
import 'package:crazyfood_app/pages/successpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black, // status bar color
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
      ),
      debugShowCheckedModeBanner: false,
      title: "Crazyfood",
      initialRoute: "/splash",
      routes: {
        "/splash": (BuildContext context) => ScreenSplash(),
        "/login": (BuildContext context) => ScreenLogin(),
        "/register": (BuildContext context) => ScreenRegister(),
        "/home": (BuildContext context) => ScreenHome(),
        "/addressmanager": (BuildContext context) => ScreenAddressManager(),
        "/checkout": (BuildContext context) => ScreenCheckout(),
        "/success": (BuildContext context) => ScreenSuccess(),
        "/orders": (BuildContext context) => ScreenOrders(),
      },
    );
  }
}
