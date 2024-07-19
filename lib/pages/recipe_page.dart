import 'package:flutter/material.dart';
import 'package:mother_ai/components/constant.dart';

import 'package:mother_ai/components/geminiai_service.dart';
import 'package:mother_ai/theme/theme.dart';



class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController productsController = TextEditingController();
  String? recipe;
  bool isLoading = false;
  final geminiAIService = GeminiaiService(myApiKey!);

  void getRecipe() async {
    setState(() {
      isLoading = true;
    });

    try {
      String age = ageController.text;
      String products = productsController.text.isNotEmpty
          ? productsController.text
          : 'only with the ingredients suitable for baby\'s age';

      final response = await geminiAIService.getRecipe(age, products);
      setState(() {
        recipe = response;
      });
    } catch (e) {
      setState(() {
        recipe = 'Error: ${e.toString()}';
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
        title: const Text('Baby Recipe Generator'),
        backgroundColor:  const Color.fromARGB(0, 47, 175, 143),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Baby\'s Age (ex. 11 months)'),
              ),
              TextField(
                controller: productsController,
                decoration: const InputDecoration(
                  labelText: 'Products (optional)',
                  hintText: 'Enter products or leave blank',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: getRecipe,
                child: const Text('Get Recipe'),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const CircularProgressIndicator()
              else if (recipe != null)
                Text(
                  recipe!,
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}