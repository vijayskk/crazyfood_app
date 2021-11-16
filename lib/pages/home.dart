// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:crazyfood_app/components/showcase.dart';
import 'package:crazyfood_app/subpages/search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            setState(() {
              currentindex = i;
            });
          },
          currentIndex: currentindex,
          fixedColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                activeIcon: Icon(Icons.home)),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                label: 'search',
                activeIcon: Icon(Icons.search)),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Basket',
                activeIcon: Icon(Icons.shopping_cart)),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
              activeIcon: Icon(Icons.account_circle_sharp),
            ),
          ],
        ),
        body: (currentindex == 0)
            ? ShowCase()
            : (currentindex == 1)
                ? SubScreenSearch()
                : (currentindex == 2)
                    ? Center(
                        child: Text("Cart"),
                      )
                    : Center(
                        child: Text("Account"),
                      ));
  }

  logout(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool status = await sp.clear();
    if (status) {
      Navigator.of(context).pushReplacementNamed('/splash');
    }
  }
}
