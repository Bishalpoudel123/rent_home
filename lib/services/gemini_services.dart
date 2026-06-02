import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // TODO: Replace with your actual Gemini API key from https://aistudio.google.com
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  /// AI assistant for room search — understands Nepali + English
  static Future<String> searchRooms(String userQuery) async {
    const systemPrompt = '''
तपाईं "कोठा खोज" app को AI assistant हुनुहुन्छ। 
तपाईंले Nepal मा कोठा खोज्न मद्दत गर्नुहुन्छ।
User ले Nepali वा English मा सोधेको कुरा बुझेर helpful reply दिनुहोस्।
जवाफ छोटो र सिधा दिनुहोस्। Nepali मा सोधे Nepali मा, English मा सोधे English मा जवाफ दिनुहोस्।
Room filter suggestions दिँदा यो format use गर्नुहोस्:
- Type: (1BHK/2BHK/flat/hostel)
- Area: (जिल्ला वा ठाउँ)
- Budget: (NPR amount)
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': '$systemPrompt\n\nUser: $userQuery'}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ??
            'माफ गर्नुहोस्, जवाफ दिन सकिएन।';
      } else {
        return 'API error: ${response.statusCode}. API key check गर्नुहोस्।';
      }
    } catch (e) {
      return 'इन्टरनेट connection check गर्नुहोस्।';
    }
  }

  /// Auto-generate room description from basic inputs
  static Future<String> generateRoomDescription({
    required String type,
    required String area,
    required int price,
    required List<String> facilities,
  }) async {
    final prompt = '''
Nepal को $area मा $type कोठाको professional description लेख्नुहोस्।
Price: NPR $price/month
Facilities: ${facilities.join(', ')}
150 words भन्दा कम, Nepali र English mix मा लेख्नुहोस्।
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {'maxOutputTokens': 300}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  /// Smart price suggestion for landlords
  static Future<String> suggestPrice({
    required String type,
    required String area,
    required List<String> facilities,
  }) async {
    final prompt = '''
Nepal को $area मा $type को लागि monthly rent suggest गर्नुहोस्।
Facilities: ${facilities.join(', ')}
Current Nepal market rate अनुसार NPR amount मात्र दिनुहोस्।
Format: "NPR X,XXX - NPR X,XXX"
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {'maxOutputTokens': 100}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}