import 'package:flutter/cupertino.dart';

class BackGroundLogo extends StatelessWidget {
  final Widget child;
  const BackGroundLogo({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Center(
            child: Opacity(
                opacity: 0.2,
                child: Image.asset('assets/logo.jpeg')),

          ),
          child,
        ],
      ),
    );
  }
}
