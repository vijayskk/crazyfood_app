import 'package:crazyfood_app/subpages/showcase.dart';
import 'package:crazyfood_app/subpages/account.dart';
import 'package:crazyfood_app/subpages/cart.dart';
import 'package:crazyfood_app/subpages/search.dart';
import 'package:flutter/material.dart';

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
            setStateIfMounted(() {
              currentindex = i;
            });
          },
          backgroundColor: Colors.white,
          currentIndex: currentindex,
          fixedColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: const [
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
        body: SafeArea(
          child: (currentindex == 0)
              ? const ShowCase()
              : (currentindex == 1)
                  ? const SubScreenSearch()
                  : (currentindex == 2)
                      ? const SubScreenCart()
                      : const SubScreenAccount(),
        ));
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
