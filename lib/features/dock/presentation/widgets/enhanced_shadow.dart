import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class EnhancedShadow extends StatelessWidget {
  final Widget child;
  final double shadowIntensity;
  final double glowIntensity;
  final BorderRadius borderRadius;

  const EnhancedShadow({
    super.key,
    required this.child,
    this.shadowIntensity = 1.0,
    this.glowIntensity = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1 * glowIntensity),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2 * shadowIntensity),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1 * shadowIntensity),
            spreadRadius: 0,
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 5 * glowIntensity,
            sigmaY: 5 * glowIntensity,
          ),
          child: child,
        ),
      ),
    );
  }
}
