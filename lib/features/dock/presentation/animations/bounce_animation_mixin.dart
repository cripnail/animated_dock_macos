import 'package:flutter/material.dart';

mixin BounceAnimationMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController bounceController;
  late Animation<double> bounceAnimation;

  @override
  void initState() {
    super.initState();
    bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 0.8)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25.0,
      ),
    ]).animate(bounceController);
  }

  void startBounceAnimation() {
    bounceController.forward(from: 0.0);
  }

  @override
  void dispose() {
    bounceController.dispose();
    super.dispose();
  }
}
