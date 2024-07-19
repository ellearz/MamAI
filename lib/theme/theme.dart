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
           Color.fromARGB(0, 47, 175, 143),
            Color.fromARGB(0, 36, 140, 114),
            Color.fromARGB(0, 51, 205, 166),
            Color.fromARGB(0, 27, 133, 107),
            Color.fromARGB(0, 36, 140, 114),
            Color.fromARGB(0, 4, 75, 57),
            Color.fromARGB(0, 36, 140, 114),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

Image logo = Image.asset('assets/mamai_appbar.png', width: 100, height: 100);

