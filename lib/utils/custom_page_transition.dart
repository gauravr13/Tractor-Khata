import 'package:flutter/material.dart';

class ScaleFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const ScaleFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Pop-up animation (Scale + Fade)
    // Using easeOutBack for a slight "pop" effect
    var curve = Curves.easeOutBack;
    var scaleTween = Tween<double>(begin: 0.9, end: 1.0).chain(CurveTween(curve: curve));
    var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut));

    return FadeTransition(
      opacity: animation.drive(fadeTween),
      child: ScaleTransition(
        scale: animation.drive(scaleTween),
        child: child,
      ),
    );
  }
}
