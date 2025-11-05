import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'quote_service.dart';

void main() {
  runApp(const LifeCountdownApp());
}

class LifeCountdownApp extends StatelessWidget {
  const LifeCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LifeCountdownProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Life Countdown Widget',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LifeCountdownProvider>().startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Consumer<LifeCountdownProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildCountdown(provider)),
                  _buildProgressBar(provider),
                  _buildQuoteSection(),
                  _buildToggleButton(provider),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your Life Clock ⏳',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            icon: const Icon(Icons.brightness_6, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown(LifeCountdownProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        children: [
          _buildTimeUnit('Years', provider.years.toString()),
          _buildTimeUnit('Months', provider.months.toString()),
          _buildTimeUnit('Days', provider.days.toString()),
          _buildTimeUnit('Hours', provider.hours.toString()),
          _buildTimeUnit('Minutes', provider.minutes.toString()),
          _buildTimeUnit('Seconds', provider.seconds.toString()),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String label, String value) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00d4ff),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(LifeCountdownProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: provider.lifeProgress,
              strokeWidth: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00d4ff)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${(provider.lifeProgress * 100).toInt()}% Lived',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteSection() {
    return Consumer<LifeCountdownProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            provider.currentQuote,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(LifeCountdownProvider provider) {
    return ElevatedButton(
      onPressed: provider.toggleMode,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00d4ff),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        provider.showingLived ? 'Show Time Remaining' : 'Show Time Lived',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LifeCountdownProvider extends ChangeNotifier {
  final DateTime birthDate = DateTime(2003, 11, 13);
  final int lifeExpectancy = 80;
  bool showingLived = false;
  
  int years = 0, months = 0, days = 0, hours = 0, minutes = 0, seconds = 0;
  double lifeProgress = 0.0;
  String currentQuote = "Make every second legendary.";
  
  final List<String> quotes = [
    "Make every second legendary.",
    "Time is your most valuable asset.",
    "Be the story you want remembered.",
    "1% better than yesterday.",
    "Every moment is a fresh beginning.",
    "Your time is limited, make it count.",
  ];
  
  int _quoteIndex = 0;

  void startTimer() {
    _updateCountdown();
    Stream.periodic(const Duration(seconds: 1)).listen((_) {
      _updateCountdown();
    });
    
    Stream.periodic(const Duration(seconds: 10)).listen((_) {
      _rotateQuote();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final expectedDeath = DateTime(birthDate.year + lifeExpectancy, birthDate.month, birthDate.day);
    
    final totalLife = expectedDeath.difference(birthDate);
    final lived = now.difference(birthDate);
    final remaining = expectedDeath.difference(now);
    
    lifeProgress = lived.inMilliseconds / totalLife.inMilliseconds;
    
    final targetDuration = showingLived ? lived : remaining;
    
    years = (targetDuration.inDays / 365.25).floor();
    months = ((targetDuration.inDays % 365.25) / 30.44).floor();
    days = targetDuration.inDays % 30;
    hours = targetDuration.inHours % 24;
    minutes = targetDuration.inMinutes % 60;
    seconds = targetDuration.inSeconds % 60;
    
    notifyListeners();
  }

  void _rotateQuote() {
    _quoteIndex = (_quoteIndex + 1) % quotes.length;
    currentQuote = quotes[_quoteIndex];
    notifyListeners();
  }

  void toggleMode() {
    showingLived = !showingLived;
    _updateCountdown();
  }
}