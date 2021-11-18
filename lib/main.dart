import 'package:crazyfood_app/pages/addressmanager.dart';
import 'package:crazyfood_app/pages/checkout.dart';
import 'package:crazyfood_app/pages/home.dart';
import 'package:crazyfood_app/pages/login.dart';
import 'package:crazyfood_app/pages/orders.dart';
import 'package:crazyfood_app/pages/register.dart';
import 'package:crazyfood_app/pages/splash.dart';
import 'package:crazyfood_app/pages/successpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
        "/splash": (BuildContext context) => const ScreenSplash(),
        "/login": (BuildContext context) => const ScreenLogin(),
        "/register": (BuildContext context) => const ScreenRegister(),
        "/home": (BuildContext context) => const ScreenHome(),
        "/addressmanager": (BuildContext context) =>
            const ScreenAddressManager(),
        "/checkout": (BuildContext context) => const ScreenCheckout(),
        "/success": (BuildContext context) => const ScreenSuccess(),
        "/orders": (BuildContext context) => const ScreenOrders(),
      },
    );
  }
}
