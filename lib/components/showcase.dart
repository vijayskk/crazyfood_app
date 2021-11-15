// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:crazyfood_app/components/itemcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class ShowCase extends StatefulWidget {
  const ShowCase({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowCase> createState() => _ShowCaseState();
}

class _ShowCaseState extends State<ShowCase> {
  int currentcat = 0;
  List? data;
  String currentcategory = "fastfood";

  getData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    if (token == null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/splash', (route) => false);
    } else {
      Response res = await post(
        Uri.parse("https://crazyfood-server.vercel.app/api/items/getall"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"token": token}),
      );
      print(res.body);
      if (res.statusCode == 200) {
        List getdata = jsonDecode(res.body);
        setState(() {
          data = getdata.map((e) {
            if (currentcategory == e["itemcategory"]) {
              return e;
            }
          }).toList();
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: Image.network(
                'https://elements-cover-images-0.imgix.net/b7baf8c8-ba17-4e35-9865-0fdeb552e7cf?auto=compress&crop=edges&fit=crop&fm=jpeg&h=630&w=1200&s=beffa2284fb0f3a624c1949831af34d7',
                fit: BoxFit.cover,
              ),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (ctx, index) {
                  if (currentcat == index) {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        width: 80,
                        height: 50,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_food,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Fastfood",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 5,
                                  blurRadius: 5)
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Color((math.Random().nextDouble() * 0x000000)
                                    .toInt())
                                .withOpacity(1)),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        width: 80,
                        height: 50,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_food,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Fastfood",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(1.0)),
                      ),
                    );
                  }
                },
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
              ),
            ),
          ),
          Expanded(
              flex: 9,
              child: (data != null)
                  ? Container(
                      padding: EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        children: data!.map((e) {
                          return ItemCard(
                              name: e["itemname"],
                              price: e["itemprice"].toString(),
                              image: e["image"],
                              data: e);
                        }).toList(),
                      ),
                    )
                  : Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ))
        ],
      ),
    );
  }
}
