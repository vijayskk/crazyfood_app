import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderTile extends StatefulWidget {
  Map data;
  OrderTile({Key? key, required this.data}) : super(key: key);

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  String? nowstatus;
  String? token;
  getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString('token');
    });
    if (token != null) {
      checkStatus(widget.data["orderId"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map order = jsonDecode(widget.data["order"]);
    List items = order["items"];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                Image.network(
                    "https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=${widget.data["orderId"]}"),
                SizedBox(
                  height: 5,
                ),
                Text("Show this at delivery")
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Text(
              "Items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: items.map((e) {
              return ListTile(
                title: Text(e["item"]["itemname"].toString()),
                subtitle: Text("₹" + e["item"]["itemprice"].toString()),
                leading: Image.network(e["item"]["image"]),
                trailing: Text("Nos: ${e["quantity"].toString()}"),
              );
            }).toList(),
          ),
          SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
            child: Text(
              "Bill Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Item Total",
                      textScaleFactor: 1,
                    ),
                    Text(
                      "₹" + (int.parse(order["totalamound"]) - 65).toString(),
                      textScaleFactor: 1,
                    ),
                  ],
                ),
                const Divider(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Restaurant charges",
                      textScaleFactor: 1,
                    ),
                    Text(
                      "₹5",
                      textScaleFactor: 1,
                    ),
                  ],
                ),
                const Divider(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Delivery charges",
                      textScaleFactor: 1,
                    ),
                    Text(
                      "₹60",
                      textScaleFactor: 1,
                    ),
                  ],
                ),
                const Divider(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total to pay",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹" + order["totalamound"],
                      textScaleFactor: 1.2,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(
                  height: 30,
                )
              ],
            ),
          ),
          (nowstatus != null)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          nowstatus!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  checkStatus(String orderId) async {
    Response res = await post(
      Uri.parse("https://crazyfood-server.vercel.app/api/orders/trackorder"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"token": token!, "orderId": orderId}),
    );
    print(res.body);
    setState(() {
      nowstatus = jsonDecode(res.body)["status"];
    });
  }
}
