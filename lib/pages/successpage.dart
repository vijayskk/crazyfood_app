import 'package:crazyfood_app/functions/confetti.dart';
import 'package:flutter/material.dart';

class ScreenSuccess extends StatefulWidget {
  const ScreenSuccess({Key? key}) : super(key: key);

  @override
  State<ScreenSuccess> createState() => _ScreenSuccessState();
}

class _ScreenSuccessState extends State<ScreenSuccess> {
  hidepop() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    hidepop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          const ConfettiSample(),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 1),
                    builder: (ctx, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.check_circle_outline_outlined,
                      size: 50,
                      color: Colors.green[800],
                    )),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  builder: (ctx, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: const Text(
                    "Order placed",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
