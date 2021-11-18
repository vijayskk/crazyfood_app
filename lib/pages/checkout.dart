import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crazyfood_app/functions/cartfunction.dart';
import 'package:crazyfood_app/pages/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenCheckout extends StatefulWidget {
  const ScreenCheckout({Key? key}) : super(key: key);

  @override
  State<ScreenCheckout> createState() => _ScreenCheckoutState();
}

class _ScreenCheckoutState extends State<ScreenCheckout> {
  List? cartdata;
  List<String>? addresses;
  String? selectedaddress;
  String? token;
  List? details;
  bool isLoading = false;
  getCart() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? cart = sp.getString('cart');
    setState(() {
      token = sp.getString('token');
      details = [
        sp.getString('name'),
        sp.getString('email'),
        sp.getString('mobileno')
      ];
    });
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

  getAddress() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String>? adr = sp.getStringList('address');
    if (adr == null) {
      setState(() {
        addresses = [];
      });
    } else {
      setState(() {
        addresses = adr;
        if (adr.isNotEmpty) {
          selectedaddress = adr[0];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCart();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: (cartdata != null && addresses != null)
                ? (cartdata!.isNotEmpty)
                    ? ListView(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 20),
                              child: Text(
                                "Items to checkout",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Column(
                              children: cartdata!.map((e) {
                            return ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (ctx) => ScreenDetails(
                                          data: e["item"],
                                        ),
                                      ),
                                    )
                                    .then((onGoBack));
                              },
                              contentPadding: const EdgeInsets.all(10),
                              title: Text(e["item"]["itemname"].toString()),
                              subtitle:
                                  Text("₹" + e["item"]["itemprice"].toString()),
                              leading: CachedNetworkImage(
                                  imageUrl: e["item"]["image"]),
                              trailing: SizedBox(
                                width: 170,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              if (e["quantity"] > 0) {
                                                removeCart(
                                                    e["item"], cartdata!);
                                              }
                                            },
                                            onLongPress: () {
                                              removeAllCart(
                                                  e["item"], cartdata!);
                                            },
                                            child: const Text(
                                              "-",
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        Text(
                                          e["quantity"].toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              addCart(e["item"], cartdata!);
                                            },
                                            child: const Text(
                                              "+",
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList()),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 20),
                              child: Text(
                                "Pick a delivery address",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: addresses!.map((e) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        selectedaddress = e;
                                      });
                                    },
                                    title: Text(e),
                                    leading: (selectedaddress == e)
                                        ? const Icon(Icons.check_circle_sharp)
                                        : const SizedBox(
                                            height: 0,
                                          ),
                                  ),
                                  const Divider()
                                ],
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60.0, vertical: 10),
                            child: RaisedButton(
                              color: Colors.indigo[900],
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      final _addressController =
                                          TextEditingController();
                                      final _formkey = GlobalKey<FormState>();
                                      return Form(
                                        key: _formkey,
                                        child: SimpleDialog(
                                          title: const Text("Add an address"),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: TextFormField(
                                                validator: (e) {
                                                  if (e != null &&
                                                      e.length > 9) {
                                                    return null;
                                                  } else {
                                                    return 'Address need atleast 10 charecters';
                                                  }
                                                },
                                                controller: _addressController,
                                                maxLines: 6,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Enter an address",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 18.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (_formkey
                                                            .currentState!
                                                            .validate()) {
                                                          addAddress(
                                                              _addressController
                                                                  .text);
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        }
                                                      },
                                                      child: const Text(
                                                          "Add address")),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              shape: const StadiumBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add, color: Colors.white),
                                  Text(
                                    "Add an address",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 20),
                              child: Text(
                                "Bill Details",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Item Total",
                                      textScaleFactor: 1.2,
                                    ),
                                    Text(
                                      "₹" + getTotal(cartdata!).toString(),
                                      textScaleFactor: 1.2,
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Restaurant charges",
                                      textScaleFactor: 1.2,
                                    ),
                                    Text(
                                      "₹5",
                                      textScaleFactor: 1.2,
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Delivery charges",
                                      textScaleFactor: 1.2,
                                    ),
                                    Text(
                                      "₹60",
                                      textScaleFactor: 1.2,
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total to pay",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "₹" +
                                          (65 + getTotal(cartdata!)).toString(),
                                      textScaleFactor: 1.5,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 20),
                              child: Text(
                                "Select Payment Method",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const ListTile(
                                      title: Text("Cash on Delivery"),
                                      subtitle: Text("Pay at your doorstep"),
                                      leading: Icon(Icons.money)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          style: BorderStyle.solid,
                                          color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const ListTile(
                                      title: Text("Debit/Credit Card"),
                                      subtitle: Text("Coming Soon"),
                                      leading:
                                          Icon(Icons.calendar_view_day_sharp),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          style: BorderStyle.solid,
                                          color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const ListTile(
                                      title: Text("Upi Payment"),
                                      subtitle: Text("Coming Soon"),
                                      leading: Icon(Icons.phonelink_ring_sharp),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: RaisedButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    color: Colors.indigo[900],
                                    shape: const StadiumBorder(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                            Icons.check_circle_outline_outlined,
                                            color: Colors.white),
                                        Text(
                                          "Place order",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      if (selectedaddress != null &&
                                          cartdata != null &&
                                          cartdata!.isNotEmpty &&
                                          details != null &&
                                          token != null) {
                                        Map order = bakeAnOrderString(
                                            cartdata!,
                                            selectedaddress!,
                                            "Cash on delivery",
                                            getTotal(cartdata!).toString(),
                                            details!);
                                        setState(() {
                                          isLoading = true;
                                        });
                                        placeOrder(order, token!);
                                      } else if (selectedaddress == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              "Please add an address"),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.red[900],
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 100),
                                        ));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : const Center(
                        child: Text(
                          "Nothing to checkout",
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
          (isLoading)
              ? Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
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

  addAddress(String str) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (addresses != null) {
      await sp.setStringList('address', [...addresses!, str]);
      await getAddress();
      setState(() {
        selectedaddress = str;
      });
    }
  }

  bakeAnOrderString(List cartdata, String selectedaddress, String paymethod,
      String totalamound, List details) {
    Map order = {
      "items": cartdata,
      "address": selectedaddress,
      "totalamound": totalamound,
      "paymethod": paymethod,
      "clientdetails": {
        "name": details[0],
        "email": details[1],
        "mobileno": details[2]
      }
    };
    return order;
  }

  placeOrder(Map order, String token) async {
    Response res = await post(
      Uri.parse("https://crazyfood-server.vercel.app/api/orders/placeorder"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"token": token, "order": jsonEncode(order)}),
    );
    if (res.statusCode == 200) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      List? prevorders = sp.getStringList('orders');
      if (prevorders == null || prevorders.isEmpty) {
        await sp.setStringList(
            'orders', [jsonEncode(jsonDecode(res.body)["order"])]);
      } else {
        await sp.setStringList('orders',
            [...prevorders, jsonEncode(jsonDecode(res.body)["order"])]);
      }
      Navigator.pushReplacementNamed(context, '/success');
    }
  }
}
