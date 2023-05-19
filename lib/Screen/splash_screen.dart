import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocr/main.dart';

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool selected = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        selected = !selected;
      });
    });

    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => MyHomePage(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 4),
            height: selected ? 300 : 10,
            width: selected ? 300 : 10,
            curve: Curves.easeOutCirc,
            decoration: const BoxDecoration(
                color: Colors.transparent, shape: BoxShape.circle),
            child: Image.asset(
              'assets/elm.png',
            ),
          ),
        ),
      ),
    );
  }
}
