import 'package:http/http.dart' as http;
import 'dart:convert';



class GeminiaiService {
  final String apiKey;

  GeminiaiService(this.apiKey);

  Future<String> getRecipe(String age, String products) async {
    const apiKey = 'AIzaSyBelKKilDVguogMhHOu2nRMCP2CbMie_9Q';
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'text-davinci-003', // or the model you prefer
        'prompt': 'Create a baby recipe for a baby aged $age months using these products: $products',
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to load recipe');
    }
  }
}