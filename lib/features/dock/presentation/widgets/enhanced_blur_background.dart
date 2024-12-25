import 'package:flutter/material.dart';
import 'dart:ui';

class EnhancedBlurBackground extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final double opacity;
  final BorderRadius? borderRadius;

  const EnhancedBlurBackground({
    super.key,
    required this.child,
    this.blurSigma = 20.0,
    this.opacity = 0.2,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // First blur layer for background
        ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurSigma,
              sigmaY: blurSigma,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((opacity * 255).round()),
                borderRadius: borderRadius,
              ),
              child: child,
            ),
          ),
        ),
        // Second blur layer for glow effect
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigma / 2,
                sigmaY: blurSigma / 2,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha((0.1 * 255).round()),
                      Colors.white.withAlpha((0.05 * 255).round()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
