import 'package:flutter/material.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 212, 0),
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            maximumSize: const Size.fromHeight(50),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            textStyle: const TextStyle(
              fontFamily: 'lato',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          onPressed: null,
          child: Center(
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 212, 0),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
        ));
  }
}
