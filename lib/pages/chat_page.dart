import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mother_ai/components/constant.dart';
import 'package:mother_ai/model/chat_model.dart';
import 'package:mother_ai/theme/theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController promptController = TextEditingController();
  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: myApiKey!,
      generationConfig: GenerationConfig(maxOutputTokens: 1000));

  // Replace with your actual API key

  final List<ChatModel> prompt = [];

  Future<void> sendMessage() async {
    final message = promptController.text;
    setState(() {
      promptController.clear();

      prompt.add(ChatModel(
        isPrompt: true,
        message: message,
        time: DateTime.now(),
      ));
    });

    final content = [Content.text(message)];

    // Add a "safety check" for the prompt
    if (_isMotherhoodRelated(message)) {
      final response = await model.generateContent(content);
      setState(() {
        prompt.add(ChatModel(
          isPrompt: false,
          message: response.text ?? ' ',
          time: DateTime.now(),
        ));
      });
    } else {
      setState(() {
        prompt.add(ChatModel(
          isPrompt: false,
          message:
              'I can only answer questions related to motherhood, baby, or pregnancy. Please try again.',
          time: DateTime.now(),
        ));
      });
    }
  }

  // Helper function to check if the message is related to motherhood, baby, or pregnancy
  bool _isMotherhoodRelated(String message) {
    final keywords = [
      'motherhood',
      'mom',
      'baby',
      'pregnancy',
      'child',
      'newborn',
      'nurturing',
      'caring',
      'loving',
      'maternal',
      'supportive',
      'protective',
      'devoted',
      'infant',
      'toddler',
      'cherub',
      'parenting',
      'breastfeeding',
      'diapers',
      'cradle',
      'nursery',
      'stroller',
      'teething',
      'pacifier',
      'swaddling',
      'milestones',
      'sleep'
    ];
    for (final keyword in keywords) {
      if (message.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 54, 134, 114),
        title: const Text('Ask MamAI'),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Information bar
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 213, 212, 196),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Ask MamAI anything related to motherhood or your baby\'s development.',
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                  height: 10), // Add some space between the bar and the chat
              Expanded(
                child: ListView.builder(
                  itemCount: prompt.length,
                  itemBuilder: (context, index) {
                    final message = prompt[index];
                    return userPrompt(
                      isPrompt: message.isPrompt,
                      message: message.message,
                      date: DateFormat('hh:mm a').format(message.time),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: TextField(
                        controller: promptController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Enter a prompt here',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: const CircleAvatar(
                        radius: 29,
                        backgroundColor: Color.fromARGB(255, 47, 124, 83),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container userPrompt({
    required bool isPrompt,
    required String message,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isPrompt ? 80 : 15,
        right: isPrompt ? 15 : 80,
      ),
      decoration: BoxDecoration(
        color: isPrompt
            ? const Color.fromARGB(255, 154, 185, 155)
            : const Color.fromARGB(255, 213, 212, 196),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: isPrompt ? const Radius.circular(20) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : const Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}