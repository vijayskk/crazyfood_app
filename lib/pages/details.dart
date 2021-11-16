import 'package:flutter/material.dart';

class ScreenDetails extends StatelessWidget {
  Map data;
  int rating = 3;
  ScreenDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Hero(
                tag: data["image"],
                child: Image.network(data["image"]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["itemname"],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "₹${data["itemprice"]}",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900]),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  data["itemdescription"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Rating",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon((rating > 0) ? Icons.star : Icons.star_border),
              Icon((rating > 1) ? Icons.star : Icons.star_border),
              Icon((rating > 2) ? Icons.star : Icons.star_border),
              Icon((rating > 3) ? Icons.star : Icons.star_border),
              Icon((rating > 4) ? Icons.star : Icons.star_border),
            ],
          )
        ],
      ),
    );
  }
}
