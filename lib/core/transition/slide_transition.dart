import 'package:flutter/material.dart';

SlideTransition slideTransition(Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 2.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
    child: child,
  );
}

SlideTransition slideFromRightTransition(
  Animation<double> animation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(2.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
    child: child,
  );
}
  