
import 'package:mother_ai/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:mother_ai/pages/chat_page.dart';
import 'package:mother_ai/pages/milestone_page.dart';
import 'package:mother_ai/pages/recipe_page.dart';
import 'package:mother_ai/pages/side_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mother_ai/theme/theme.dart';
 // For loading lorem ipsum text

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   String _quote = 'You are being your Best Version of a Mom';
  // String quote = InspirationQuotes.getRandomQuote();

  // void _generateRandomQuote() {
  //   setState(() {
  //     quote = InspirationQuotes.getRandomQuote();
  //   });
  // }
Future<void> _getQuoteFromGemini() async {
    const apiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent'; // Replace with actual Gemini API endpoint
  // Replace with your actual API key

    final body = jsonEncode({
      'prompt': 'Generate an inspiring quote for a mom, something short and heartfelt.',
      'temperature': 0.7, // Adjust for creativity
      'maxOutputTokens': 50, // Limit output length
    });

    final headers = {
      'Authorization': 'Bearer $myApiKey',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(Uri.parse(apiEndpoint), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _quote = data['text'];
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _quote = 'Error fetching quote. Please try again.';
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _quote = 'Error fetching quote. Please try again.';
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: logo,
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
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _quote,
                      style: const TextStyle(fontSize: 18,),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _getQuoteFromGemini,
                      child: const Text('😊',),
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
                  _buildNavigationBox(context, 'Baby Recipe ', 'Let\'s generate a lovely recipe together','assets/recipe.jpg', const RecipePage()),
                  _buildNavigationBox(context, 'Baby Milestones ', 'To Note you baby imporant milestones','assets/baby_milestones.jpg',const MilestonePage()),
                 
                
                  _buildNavigationBox(
                    context,
                    'Chat AI',
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

  Widget _buildNavigationBox(BuildContext context, String title, String subtitle,String imagePath, Widget destinationPage) {
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
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 50, 2, 58),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
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
