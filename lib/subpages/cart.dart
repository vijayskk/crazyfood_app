import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crazyfood_app/functions/cartfunction.dart';
import 'package:crazyfood_app/pages/details.dart';
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
  }

  @override
  void initState() {
    super.initState();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 18.0, horizontal: 28),
                      child: Text(
                        "Your Cart",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
              (cartdata != null)
                  ? (cartdata!.isNotEmpty)
                      ? Expanded(
                          flex: 11,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (ctx) => ScreenDetails(
                                            data: cartdata![index]["item"],
                                          ),
                                        ),
                                      )
                                      .then((onGoBack));
                                },
                                contentPadding: const EdgeInsets.all(10),
                                title: Text(cartdata![index]["item"]["itemname"]
                                    .toString()),
                                subtitle: Text("₹" +
                                    cartdata![index]["item"]["itemprice"]
                                        .toString()),
                                leading: CachedNetworkImage(
                                    imageUrl: cartdata![index]["item"]
                                        ["image"]),
                                trailing: SizedBox(
                                  width: 170,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                if (cartdata![index]
                                                        ["quantity"] >
                                                    0) {
                                                  removeCart(
                                                      cartdata![index]["item"],
                                                      cartdata!);
                                                }
                                              },
                                              onLongPress: () {
                                                removeAllCart(
                                                    cartdata![index]["item"],
                                                    cartdata!);
                                              },
                                              child: const Text(
                                                "-",
                                                textScaleFactor: 1.5,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                          Text(
                                            cartdata![index]["quantity"]
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: TextButton(
                                                onPressed: () {
                                                  addCart(
                                                      cartdata![index]["item"],
                                                      cartdata!);
                                                },
                                                child: const Text(
                                                  "+",
                                                  textScaleFactor: 1.5,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: cartdata!.length,
                          ),
                        )
                      : const Expanded(
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
                  : const Expanded(
                      flex: 11,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: 30,
                        ),
                      ),
                    )
            ],
          ),
          (cartdata != null && cartdata!.isNotEmpty)
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/checkout');
                      },
                      label: const Text(
                        "Checkout",
                      ),
                      icon: const Icon(Icons.check_circle_outline_outlined),
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
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

  onGoBack(dynamic value) {
    getCart();
    setState(() {});
  }
}
