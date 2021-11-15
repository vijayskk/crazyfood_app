import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Text("Home"),
      ),
    );
  }

  logout(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool status = await sp.clear();
    if (status) {
      Navigator.of(context).pushReplacementNamed('/splash');
    }
  }
}
