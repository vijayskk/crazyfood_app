import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubScreenAccount extends StatefulWidget {
  const SubScreenAccount({Key? key}) : super(key: key);

  @override
  State<SubScreenAccount> createState() => _SubScreenAccountState();
}

class _SubScreenAccountState extends State<SubScreenAccount> {
  List? details;

  getDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      details = [
        sp.getString('name'),
        sp.getString('email'),
        sp.getString('mobileno')
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: (details != null)
            ? SizedBox(
                width: double.infinity,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150)),
                          child: Image.asset(
                            "assets/pp.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      details![0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      details![1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      details![2],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text("My Orders"),
                      onTap: () {
                        Navigator.of(context).pushNamed('/orders');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text("Manage Addresses"),
                      onTap: () {
                        Navigator.of(context).pushNamed('/addressmanager');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text("Logout"),
                      onTap: () {
                        logout(context);
                      },
                    ),
                  ],
                ),
              )
            : const Center(
                child: CupertinoActivityIndicator(
                  radius: 30,
                ),
              ));
  }

  logout(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool status = await sp.clear();
    if (status) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/splash', (route) => false);
    }
  }
}
