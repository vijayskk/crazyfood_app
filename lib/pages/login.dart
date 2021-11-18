import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool disableinput = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: !disableinput,
                      validator: (e) {
                        if (e != null) {
                          if (EmailValidator.validate(e)) {
                            return null;
                          } else {
                            return 'Invaied Email';
                          }
                        } else {
                          return 'Email cannot be empty';
                        }
                      },
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Email"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: !disableinput,
                      validator: (e) {
                        if (e != null) {
                          if (e.length >= 8) {
                            return null;
                          } else {
                            return 'Password must be 8 charecter or more';
                          }
                        } else {
                          return 'Password cannot be empty';
                        }
                      },
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton.filled(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            login(_usernameController.text,
                                _passwordController.text, context);
                          }
                        },
                        child: const Text("Login")),
                    const SizedBox(
                      height: 10,
                    ),
                    CupertinoButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/register');
                        },
                        child: const Text("Register instead"))
                  ],
                ),
              ),
            ),
          ),
          disableinput
              ? AnimatedOpacity(
                  duration: const Duration(milliseconds: 1),
                  opacity: disableinput ? 0.5 : 0,
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

  login(String u, String p, BuildContext ctx) async {
    setState(() {
      disableinput = true;
    });
    Response res = await post(
      Uri.parse("https://crazyfood-server.vercel.app/api/auth/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": u, "password": p}),
    );
    if (res.statusCode == 200) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString('token', jsonDecode(res.body)["token"]);
      await sp.setString('email', jsonDecode(res.body)["email"]);
      await sp.setString('name', jsonDecode(res.body)["name"]);
      await sp.setString('mobileno', jsonDecode(res.body)["mobileno"]);
      Navigator.of(ctx).pushReplacementNamed('/splash');
    } else if (res.statusCode == 401) {
      setState(() {
        disableinput = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text("Invalied email or password"),
        padding: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
    } else {
      setState(() {
        disableinput = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text("Something went wrong"),
        padding: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
    }
  }
}
