import 'dart:convert';

import 'package:crazyfood_app/components/ordertile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenOrders extends StatefulWidget {
  const ScreenOrders({Key? key}) : super(key: key);

  @override
  State<ScreenOrders> createState() => _ScreenOrdersState();
}

class _ScreenOrdersState extends State<ScreenOrders> {
  List? orders;

  getOrders() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List? odr = sp.getStringList('orders');
    if (odr == null) {
      setState(() {
        orders = [];
      });
    } else {
      setState(() {
        orders = odr;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
                  orders = null;
                });
                await Future.delayed(const Duration(milliseconds: 300));
                getOrders();
              },
              label: const Text("Refresh"),
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            )),
        title: const Text(
          "MyOrders",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: (orders != null)
            ? (orders!.isNotEmpty)
                ? ListView.builder(
                    itemCount: orders!.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: OrderTile(data: jsonDecode(orders![index])),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No Orders yet",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
            : const Center(
                child: CupertinoActivityIndicator(
                  radius: 30,
                ),
              ),
      ),
    );
  }
}
