import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  // مفتاحك الخاص بـ Hugging Face
  static const String apiKey = "omairsadeqabdulqaderahmed";

  static Future<String> analyzeProject(String idea) async {
    try {
      final url = Uri.parse(
          "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "inputs": "Analyze this project idea: $idea. Return a professional analysis including features, cost, timeline, and tech stack.",
          "parameters": {"max_new_tokens": 500}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]["generated_text"].toString();
      } else {
        return _getMockData(idea);
      }
    } catch (e) {
      return _getMockData(idea);
    }
  }

  static String _getMockData(String idea) {
// لاحظ حرف r قبل الـ """
    return r"""
✅ تحليل مقترح لمشروع: """ + idea + r"""

1. المميزات:
   - واجهة مستخدم حديثة.
   - نظام إدارة مهام متكامل.
   - إشعارات ذكية للمستخدمين.

2. التكلفة التقديرية: 2000$ - 4500$ حسب النطاق.
3. الجدول الزمني: يحتاج المشروع حوالي 3 أشهر للتنفيذ.
4. التقنيات الموصى بها: Flutter للواجهات، Firebase للباك إند.

نصيحة: ابدأ بنسخة أولية (MVP) تركز على حل المشكلة الأساسية.
""";
  }
}