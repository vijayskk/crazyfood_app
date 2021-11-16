// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:crazyfood_app/components/itemsgrid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubScreenSearch extends StatefulWidget {
  const SubScreenSearch({Key? key}) : super(key: key);

  @override
  State<SubScreenSearch> createState() => _SubScreenSearchState();
}

class _SubScreenSearchState extends State<SubScreenSearch> {
  bool isTrend = true;
  List? data;

  getData() async {
    setStateIfMounted(() {
      data = null;
    });
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
        body: jsonEncode(<String, String>{
          "token": token,
        }),
      );
      print(res.body);
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
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CupertinoSearchTextField(
                onChanged: (e) {
                  if (e == "") {
                    setStateIfMounted(() {
                      isTrend = true;
                    });
                    getData();
                  } else {
                    setStateIfMounted(() {
                      isTrend = false;
                    });
                    search(e);
                  }
                },
              ),
            ),
            (isTrend)
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "🔥Now on Trending🔥",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            (data != null)
                ? Expanded(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ItemsGrid(data: data!),
                  ))
                : Center(
                    child: CupertinoActivityIndicator(
                      radius: 30,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  search(String str) async {
    setStateIfMounted(() {
      data = null;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    if (token == null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/splash', (route) => false);
    } else {
      Response res = await post(
        Uri.parse("https://crazyfood-server.vercel.app/api/items/searchitem"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"token": token, "word": str}),
      );
      print(res.body);
      if (res.statusCode == 200) {
        List getdata = jsonDecode(res.body);
        setStateIfMounted(() {
          data = getdata;
        });
      }
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
