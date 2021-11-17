// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:crazyfood_app/functions/cartfunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubScreenCart extends StatefulWidget {
  const SubScreenCart({Key? key}) : super(key: key);

  @override
  State<SubScreenCart> createState() => _SubScreenCartState();
}

class _SubScreenCartState extends State<SubScreenCart> {
  List? cartdata;

  getCart() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? cart = sp.getString('cart');
    if (cart != null) {
      setState(() {
        cartdata = jsonDecode(cart);
      });
    } else {
      setState(() {
        cartdata = [];
      });
    }
    print(cartdata);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 28),
                  child: Text(
                    "Your Cart",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          (cartdata != null)
              ? (cartdata!.length != 0)
                  ? Expanded(
                      flex: 11,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            title: Text(cartdata![index]["item"]["itemname"]
                                .toString()),
                            contentPadding: EdgeInsets.all(10),
                            subtitle: Text("\$" +
                                cartdata![index]["item"]["itemprice"]
                                    .toString()),
                            leading: Image.network(
                                "https://media-cldnry.s-nbcnews.com/image/upload/newscms/2019_21/2870431/190524-classic-american-cheeseburger-ew-207p.jpg"),
                            trailing: SizedBox(
                              width: 150,
                              child: Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        if (cartdata![index]["quantity"] > 0) {
                                          removeCart(cartdata![index]["item"],
                                              cartdata!);
                                        }
                                      },
                                      onLongPress: () {
                                        removeAllCart(cartdata![index]["item"],
                                            cartdata!);
                                      },
                                      child: Text(
                                        "-",
                                        textScaleFactor: 2,
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  Text(
                                    cartdata![index]["quantity"].toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        addCart(cartdata![index]["item"],
                                            cartdata!);
                                      },
                                      child: Text(
                                        "+",
                                        textScaleFactor: 2,
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: cartdata!.length,
                      ),
                    )
                  : Expanded(
                      flex: 11,
                      child: Center(
                        child: Text(
                          "Nothing in your cart",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    )
              : Expanded(
                  flex: 11,
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: 30,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  addCart(Map item, List cart) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('cart', jsonEncode(addToCart(item, cart)));
    getCart();
  }

  removeCart(Map item, List cart) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('cart', jsonEncode(removeFromCart(item, cart)));
    getCart();
  }

  removeAllCart(Map item, List cart) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('cart', jsonEncode(removeAllFromCart(item, cart)));
    getCart();
  }
}
