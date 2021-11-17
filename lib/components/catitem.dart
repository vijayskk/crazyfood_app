import 'package:flutter/material.dart';

class CatItem extends StatelessWidget {
  Map data;
  CatItem({Key? key, required this.data}) : super(key: key);

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
          borderRadius: BorderRadius.circular(10),
          color: Color(int.parse("0xFF" + data["color"].substring(1))),
        ),
      ),
    );
  }
}
