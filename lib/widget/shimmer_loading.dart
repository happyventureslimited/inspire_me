import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerLoading({
    super.key,
    this.height = 20,
    this.width = double.infinity,
    this.radius = 12,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.1, 0.3, 0.4],
              begin: Alignment(-1 - 2 * _controller.value, -0.3),
              end: Alignment(1 + 2 * _controller.value, 0.3),
            ),
          ),
        );
      },
    );
  }
}
