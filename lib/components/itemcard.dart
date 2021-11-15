// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  Map data;
  String name;
  String image;
  String price;
  ItemCard(
      {Key? key,
      required this.name,
      required this.price,
      required this.image,
      required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            image,
            loadingBuilder: (ctx, child, loadingevent) {
              if (loadingevent == null) {
                return child;
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: CupertinoActivityIndicator(),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: Text(
                  "\$$price",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
