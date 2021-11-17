import 'package:flutter/material.dart';

class CatItemSelected extends StatelessWidget {
  Map data;

  CatItemSelected({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        width: 80,
        height: 50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data["emoji"]),
              SizedBox(
                height: 6,
              ),
              Text(
                data["category"],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.grey, spreadRadius: 5, blurRadius: 5)
          ],
          borderRadius: BorderRadius.circular(10),
          color: Color(int.parse("0xFF" + data["color"].substring(1))),
        ),
      ),
    );
  }
}
