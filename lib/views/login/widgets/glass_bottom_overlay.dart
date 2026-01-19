import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomOverlay extends StatelessWidget {
  const GlassBottomOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border(
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
