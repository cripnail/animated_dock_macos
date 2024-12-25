import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DockReflection extends StatelessWidget {
  final Widget child;
  final double reflectionHeight;
  final double opacity;

  const DockReflection({
    super.key,
    required this.child,
    this.reflectionHeight = 20.0,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        Transform(
          transform: Matrix4.identity()
            ..scale(1.0, -0.5)
            ..setEntry(3, 2, 0.002),
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              child,
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(opacity),
                        Colors.white.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}