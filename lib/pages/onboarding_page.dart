import 'package:flutter/material.dart';
import 'package:mother_ai/pages/home_page.dart';
import 'package:mother_ai/theme/theme.dart';


class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/mamai_logo.png',
                  width: 300,
                  height: 300,
                ),

                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 187, 10, 200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Let\'s Go'),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

