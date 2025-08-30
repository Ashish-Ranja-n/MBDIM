import 'package:flutter/material.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  const ShimmerPlaceholder({
    super.key,
    this.height = 20,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius,
      ),
    );
  }
}
