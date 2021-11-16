// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({Key? key}) : super(key: key);

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

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
                    Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
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
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Email"),
                    ),
                    SizedBox(
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: !disableinput,
                      validator: (e) {
                        if (e == _passwordController.text) {
                          return null;
                        } else {
                          return 'Passwords wont match';
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Confirm Password",
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: !disableinput,
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Full Name",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: !disableinput,
                      validator: (e) {
                        if (e != null) {
                          if (e.length == 10) {
                            return null;
                          } else {
                            return 'Mobile number must be 10 digits';
                          }
                        } else {
                          return 'Mobile No cannot be empty';
                        }
                      },
                      controller: _mobileController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Mobile Number",
                          suffix: Text(
                            "+91",
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoButton.filled(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            register(
                                _usernameController.text,
                                _passwordController.text,
                                _nameController.text,
                                _mobileController.text,
                                context);
                          }
                          ;
                        },
                        child: Text("Register")),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text("Already have account"))
                  ],
                ),
              ),
            ),
          ),
          disableinput
              ? AnimatedOpacity(
                  duration: Duration(milliseconds: 1),
                  opacity: disableinput ? 0.5 : 0,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : SizedBox(
                  height: 0,
                )
        ],
      ),
    );
  }

  register(String u, String p, String n, String m, BuildContext ctx) async {
    setState(() {
      disableinput = true;
    });
    Response res = await post(
      Uri.parse("https://crazyfood-server.vercel.app/api/auth/adduser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": u,
        "name": n,
        "mobileno": m,
        "password": p
      }),
    );
    print(res.body);
    if (res.statusCode == 200) {
      Response res2 = await post(
        Uri.parse("https://crazyfood-server.vercel.app/api/auth/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"email": u, "password": p}),
      );
      if (res2.statusCode == 200) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        await sp.setString('token', jsonDecode(res2.body)["token"]);
        await sp.setString('email', jsonDecode(res2.body)["email"]);
        await sp.setString('name', jsonDecode(res2.body)["name"]);
        await sp.setString('mobileno', jsonDecode(res2.body)["mobileno"]);
        Navigator.of(ctx).pushReplacementNamed('/home');
      } else {
        setState(() {
          disableinput = false;
        });
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text("Something went wrong"),
          padding: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ));
      }
    } else {
      setState(() {
        disableinput = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
        padding: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
    }
  }
}
