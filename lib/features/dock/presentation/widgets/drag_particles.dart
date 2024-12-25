import 'dart:math';
import 'package:flutter/material.dart';

class DragParticle {
  Offset position;
  Offset velocity;
  double life;
  Color color;
  double size;

  DragParticle({
    required this.position,
    required this.velocity,
    this.life = 1.0,
    required this.color,
    required this.size,
  });

  bool update() {
    position += velocity;
    velocity *= 0.95; // Замедление
    life *= 0.95; // Затухание
    return life > 0.1;
  }
}

class DragParticlesPainter extends CustomPainter {
  final List<DragParticle> particles;

  DragParticlesPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          particle.position, particle.size * particle.life, paint);
    }
  }

  @override
  bool shouldRepaint(DragParticlesPainter oldDelegate) => true;
}

class DragParticlesEffect extends StatefulWidget {
  final Offset position;
  final bool isActive;

  const DragParticlesEffect({
    super.key,
    required this.position,
    required this.isActive,
  });

  @override
  State<DragParticlesEffect> createState() => _DragParticlesEffectState();
}

class _DragParticlesEffectState extends State<DragParticlesEffect>
    with SingleTickerProviderStateMixin {
  final List<DragParticle> _particles = [];
  final Random _random = Random();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60 FPS
    )..addListener(_updateParticles);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DragParticlesEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }

    if (widget.isActive && widget.position != oldWidget.position) {
      _emitParticles();
    }
  }

  void _emitParticles() {
    final baseColor = Colors.white;
    for (int i = 0; i < 3; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 2.0 + _random.nextDouble() * 3.0;
      _particles.add(DragParticle(
        position: widget.position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed,
        ),
        color: baseColor,
        size: 2.0 + _random.nextDouble() * 2.0,
      ));
    }
  }

  void _updateParticles() {
    setState(() {
      _particles.removeWhere((particle) => !particle.update());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DragParticlesPainter(_particles),
      size: Size.infinite,
    );
  }
}
