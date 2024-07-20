import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(0, 9, 41, 33),
            Color.fromARGB(0, 188, 213, 207),
            Color.fromARGB(0, 51, 205, 166),
            Color.fromARGB(0, 37, 85, 73),
            Color.fromARGB(0, 43, 165, 134),
            Color.fromARGB(0, 4, 75, 57),
            Color.fromARGB(0, 21, 82, 66),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

Image logo = Image.asset('assets/mamai_appbar.png', width: 100, height: 100);