import 'package:flutter/material.dart';

mixin AnimationControllerMixin<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
  }

  void toggleOverlay() {
    if (animationController.isDismissed) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
