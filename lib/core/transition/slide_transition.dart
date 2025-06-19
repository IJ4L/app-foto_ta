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
