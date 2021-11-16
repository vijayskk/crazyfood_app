// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:crazyfood_app/components/catitem.dart';
import 'package:crazyfood_app/components/catitemselected.dart';
import 'package:crazyfood_app/components/itemcard.dart';
import 'package:crazyfood_app/components/itemsgrid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  String? currentcategory;
  List? fullcats;
  getData() async {
    setState(() {
      data = null;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    String? cat = sp.getString('cats');
    if (token == null || cat == null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/splash', (route) => false);
    } else {
      List cats = jsonDecode(cat);
      setState(() {
        fullcats = cats;
      });
      Response res = await post(
        Uri.parse(
            "https://crazyfood-server.vercel.app/api/items/getbycategory"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "token": token,
          "category": cats[currentcat]["category"]
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        List getdata = jsonDecode(res.body);
        setState(() {
          data = getdata;
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
            child: (fullcats != null)
                ? SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: fullcats!.length,
                      itemBuilder: (ctx, index) {
                        if (currentcat == index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentcat = index;
                                getData();
                              });
                            },
                            child: CatItemSelected(
                              data: fullcats![index],
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentcat = index;
                                getData();
                              });
                            },
                            child: CatItem(
                              data: fullcats![index],
                            ),
                          );
                        }
                      },
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                    ),
                  )
                : Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  ),
          ),
          Expanded(
            flex: 9,
            child: (data != null)
                ? ItemsGrid(data: data!)
                : Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
