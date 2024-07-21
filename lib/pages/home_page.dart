import 'package:mother_ai/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:mother_ai/pages/chat_page.dart';
import 'package:mother_ai/pages/milestone_page.dart';
import 'package:mother_ai/pages/recipe_page.dart';
import 'package:mother_ai/pages/side_bar.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:mother_ai/theme/theme.dart';

final apiKey = myApiKey;
final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: myApiKey!);
final generationConfig = GenerationConfig(
  maxOutputTokens: 30,
  temperature: 0.9,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _quote = 'You are being your Best Version of a Mom';
  bool isLoading = false;

  Future<void> _getQuoteFromGemini() async {
    setState(() {
      isLoading = true;
    });

    try {
      final content = [
        Content.text(
            'I am a Mom, generate for me uplifting my spirit short quote, every time a new quote.')
      ];
      final response = await model.generateContent(content,
          generationConfig: generationConfig);

      setState(() {
        _quote = response.text ?? 'You are amazing human being';
      });
    } catch (e) {
      setState(() {
        _quote = 'Enjoy your day,sunshine';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: logo,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 47, 175, 143),
      ),
      drawer: const SideBar(), // Add the sidebar here
      body: GradientBackground(
        child: Column(
          children: [
            // Upper part with the inspiration quote box
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _quote,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _getQuoteFromGemini,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              '😊',
                              style: TextStyle(fontSize: 24),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            // Lower part with the three boxes
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavigationBox(
                      context,
                      'Baby Recipe ',
                      'Let\'s generate a lovely recipe together',
                      'assets/recipe.jpg',
                      const RecipePage()),
                  _buildNavigationBox(
                      context,
                      'Baby Milestones ',
                      'Note you baby\'s imporant milestones',
                      'assets/baby_milestones.jpg',
                      const MilestonePage()),
                  _buildNavigationBox(
                    context,
                    'Ask AI',
                    'I am here to assist you with baby, motherhood related topics',
                    'assets/chatAI.jpg',
                    const ChatPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBox(BuildContext context, String title,
      String subtitle, String imagePath, Widget destinationPage) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.darken)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 227, 237, 228),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 250, 255, 254),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
