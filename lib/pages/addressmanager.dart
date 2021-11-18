import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
                final _formkey = GlobalKey<FormState>();
                return Form(
                  key: _formkey,
                  child: SimpleDialog(
                    title: const Text("Add an address"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: (e) {
                            if (e != null && e.length > 9) {
                              return null;
                            } else {
                              return 'Address need atleast 10 charecters';
                            }
                          },
                          controller: _addressController,
                          maxLines: 6,
                          decoration: const InputDecoration(
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
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    addAddress(_addressController.text);
                                    Navigator.of(ctx).pop();
                                  }
                                },
                                child: const Text("Add address")),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
      body: SafeArea(
        child: (addresses != null)
            ? (addresses!.isNotEmpty)
                ? ListView.builder(
                    itemCount: addresses!.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            trailing: IconButton(
                                onPressed: () {
                                  deleteAddress(addresses![index]);
                                },
                                icon: const Icon(Icons.delete)),
                            title: Text(addresses![index]),
                            leading: const Icon(Icons.location_city),
                          ),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No addresses yet",
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
