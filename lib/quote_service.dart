import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class QuoteService {
  static const List<String> _localQuotes = [
    "Make every second legendary.",
    "Time is your most valuable asset.",
    "Be the story you want remembered.",
    "1% better than yesterday.",
    "Every moment is a fresh beginning.",
    "Your time is limited, make it count.",
    "Life is what happens while you're making plans.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "Don't count the days, make the days count.",
    "Time flies, but memories last forever.",
  ];

  static String getRandomLocalQuote() {
    final random = Random();
    return _localQuotes[random.nextInt(_localQuotes.length)];
  }

  static Future<String> fetchQuoteFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('https://zenquotes.io/api/random'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0]['q'] ?? getRandomLocalQuote();
        }
      }
    } catch (e) {
      // Fallback to local quote on error
    }
    return getRandomLocalQuote();
  }

  static String getDailyReflectionQuote() {
    final reflectionQuotes = [
      "What did you learn today?",
      "How did you grow today?",
      "What are you grateful for?",
      "What will you do differently tomorrow?",
      "How did you make someone's day better?",
    ];
    
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return reflectionQuotes[dayOfYear % reflectionQuotes.length];
  }

  static String getMorningMotivation() {
    final morningQuotes = [
      "Today is 1% better than yesterday.",
      "Make today legendary.",
      "Your future self is counting on you.",
      "Every sunrise is a new opportunity.",
      "Today's actions shape tomorrow's reality.",
    ];
    
    final random = Random();
    return morningQuotes[random.nextInt(morningQuotes.length)];
  }
}