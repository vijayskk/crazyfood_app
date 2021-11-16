// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenDetails extends StatefulWidget {
  Map data;

  ScreenDetails({Key? key, required this.data}) : super(key: key);

  @override
  State<ScreenDetails> createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  int rating = 3;
  int counter = 0;
  bool isAdded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Hero(
                tag: widget.data["image"],
                child: Image.network(widget.data["image"]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data["itemname"],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "₹${widget.data["itemprice"]}",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900]),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.data["itemdescription"],
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
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isAdded
                          ? RaisedButton(
                              shape: StadiumBorder(),
                              color: Colors.red,
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                setState(() {
                                  counter = 0;
                                  isAdded = false;
                                });
                              },
                            )
                          : RaisedButton(
                              shape: StadiumBorder(),
                              color: Colors.green,
                              child: Text(
                                "Add to cart",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                setState(() {
                                  counter++;
                                  if (counter > 0) {
                                    isAdded = true;
                                  }
                                });
                              },
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                if (counter < 2) {
                                  isAdded = false;
                                }
                                if (counter > 0) {
                                  counter--;
                                }
                              });
                            },
                            child: Text(
                              "-",
                              textScaleFactor: 3,
                              style: TextStyle(color: Colors.black),
                            )),
                        Text(
                          counter.toString(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                counter++;
                                if (counter > 0) {
                                  isAdded = true;
                                }
                              });
                            },
                            child: Text(
                              "+",
                              textScaleFactor: 3,
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
