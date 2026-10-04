import 'dart:convert';

import 'package:http/http.dart' as http;

class AIService {

  static Future<String> analyzeIdea(
      String idea,
      ) async {

    try {

      final response = await http.post(
        Uri.parse(
          "https://api.openai.com/v1/chat/completions",
        ),

        headers: {
          "Authorization":
          "Bearer YOUR_OPENAI_API_KEY",

          "Content-Type":
          "application/json",
        },

        body: jsonEncode({
          "model": "gpt-4o-mini",

          "messages": [
            {
              "role": "user",
              "content":
              "Analyze this app idea: $idea"
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);

      return data["choices"][0]["message"]
      ["content"];

    } catch (e) {

      return "AI Analysis Failed";
    }
  }
}