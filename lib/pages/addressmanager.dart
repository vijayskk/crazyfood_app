// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenAddressManager extends StatefulWidget {
  const ScreenAddressManager({Key? key}) : super(key: key);

  @override
  State<ScreenAddressManager> createState() => _ScreenAddressManagerState();
}

class _ScreenAddressManagerState extends State<ScreenAddressManager> {
  List<String>? addresses;

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
      });
    }
    print(addresses);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            )),
        title: Text(
          "Saved Addresses",
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (ctx) {
                final _addressController = TextEditingController();
                return SimpleDialog(
                  title: Text("Add an address"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _addressController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: "Enter an address",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () {
                                addAddress(_addressController.text);
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Add address")),
                        ],
                      ),
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
      body: SafeArea(
        child: (addresses != null)
            ? (addresses!.length != 0)
                ? Container(
                    child: ListView.builder(
                      itemCount: addresses!.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            ListTile(
                              trailing: IconButton(
                                  onPressed: () {
                                    deleteAddress(addresses![index]);
                                  },
                                  icon: Icon(Icons.delete)),
                              title: Text(addresses![index]),
                              leading: Icon(Icons.location_city),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "No addresses yet",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
            : Center(
                child: CupertinoActivityIndicator(
                  radius: 30,
                ),
              ),
      ),
    );
  }

  addAddress(String str) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (addresses != null) {
      await sp.setStringList('address', [...addresses!, str]);
      getAddress();
    }
  }

  deleteAddress(str) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (addresses != null) {
      addresses!.remove(str);
      await sp.setStringList('address', addresses!);
      getAddress();
    }
  }
}
