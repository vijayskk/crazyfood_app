import 'dart:convert';

import 'package:crazyfood_app/components/catitem.dart';
import 'package:crazyfood_app/components/catitemselected.dart';
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
    setStateIfMounted(() {
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
      setStateIfMounted(() {
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
      if (res.statusCode == 200) {
        List getdata = jsonDecode(res.body);
        setStateIfMounted(() {
          data = getdata;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Opacity(
          opacity: 0.8,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pushNamed('/checkout');
            },
            label: const Text("Checkout"),
            icon: const Icon(Icons.check_circle_outlined),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/banner.jpg',
                  fit: BoxFit.cover,
                ),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
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
                                setStateIfMounted(() {
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
                                setStateIfMounted(() {
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
                  : const Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
            ),
            Expanded(
              flex: 9,
              child: (data != null)
                  ? ItemsGrid(data: data!)
                  : const Center(
                      child: CupertinoActivityIndicator(
                        radius: 30,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
