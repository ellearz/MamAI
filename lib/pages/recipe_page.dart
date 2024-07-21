import 'package:flutter/material.dart';
import 'package:mother_ai/components/constant.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mother_ai/theme/theme.dart';

final apiKey = myApiKey;
final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: myApiKey!);

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

  void getRecipe() async {
    setState(() {
      isLoading = true;
    });

    try {
      String age = ageController.text;
      String products = productsController.text.isNotEmpty
          ? productsController.text
          : 'only using healthy ingredients';
      final content = [
        Content.text(
            'Create a baby recipe for a $age months baby using these products: $products.')
      ];

      final response = await model.generateContent(content);
      setState(() {
        recipe = response.text;
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
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: const Text('Baby Recipe Generator'),
        backgroundColor: const Color.fromARGB(255, 54, 134, 114),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Baby\'s Age (ex. 11 months)',
                  ),
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
                  const Center(child: CircularProgressIndicator())
                else if (recipe != null)
                  Text(
                    recipe!,
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
