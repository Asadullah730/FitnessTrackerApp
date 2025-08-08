import 'package:flutter/material.dart';

Route slideFadeRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(1.0, 0.0); // Slide from right
      const endOffset = Offset.zero;
      final tween = Tween(begin: beginOffset, end: endOffset);
      final fadeTween = Tween(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
