import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/backgroundImage4.png",
              fit: BoxFit.cover,  
              width: size.width,
              height: size.height,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(95, 68, 106, 172).withOpacity(0.6),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

