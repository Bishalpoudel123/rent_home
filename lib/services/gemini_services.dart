class GeminiService {
  Future<String> getAIResponse(String userMessage) async {
    await Future.delayed(const Duration(seconds: 1));

    return "I'm your AI assistant! I can help you find rooms, suggest roommates, or answer questions about properties. What would you like to know?";
  }

  Future<List<String>> getRoommateRecommendations(
      Map<String, dynamic> userPreferences) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      "Alice - 85% match",
      "Bob - 78% match",
      "Carol - 72% match",
    ];
  }

  static Future<String> generateRoomDescription({
    required String roomType,
    required String location,
    required String amenities,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return '''
Beautiful $roomType available in $location.

Amenities:
$amenities

Perfect for students, professionals, and families.
Well maintained property with easy access to transportation and daily necessities.
''';
  }

  static Future<int> suggestPrice({
    required String location,
    required String roomType,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (location.toLowerCase().contains('kathmandu')) {
      return 18000;
    }

    if (location.toLowerCase().contains('pokhara')) {
      return 15000;
    }

    return 12000;
  }
}