import 'package:crazyfood_app/components/itemcard.dart';
import 'package:flutter/material.dart';

class ItemsGrid extends StatelessWidget {
  List data;
  ItemsGrid({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.count(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: data.map((e) {
          return ItemCard(
              name: e["itemname"],
              price: e["itemprice"].toString(),
              image: e["image"],
              data: e);
        }).toList(),
      ),
    );
  }
}
