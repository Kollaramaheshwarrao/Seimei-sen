import 'package:flutter/material.dart';
import 'package:glance/glance.dart';

class LifeCountdownWidget extends GlanceAppWidget {
  const LifeCountdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlanceAppWidgetReceiver(
      widget: this,
      child: const LifeWidgetContent(),
    );
  }
}

class LifeWidgetContent extends StatefulWidget {
  const LifeWidgetContent({super.key});

  @override
  State<LifeWidgetContent> createState() => _LifeWidgetContentState();
}

class _LifeWidgetContentState extends State<LifeWidgetContent> {
  final DateTime birthDate = DateTime(2003, 11, 13);
  final int lifeExpectancy = 80;
  
  int years = 0, months = 0, days = 0, hours = 0;
  double progress = 0.0;
  String quote = "Make every second legendary.";

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    
    // Update every minute for widget
    Stream.periodic(const Duration(minutes: 1)).listen((_) {
      if (mounted) _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final expectedDeath = DateTime(birthDate.year + lifeExpectancy, birthDate.month, birthDate.day);
    
    final totalLife = expectedDeath.difference(birthDate);
    final lived = now.difference(birthDate);
    final remaining = expectedDeath.difference(now);
    
    setState(() {
      progress = lived.inMilliseconds / totalLife.inMilliseconds;
      years = (remaining.inDays / 365.25).floor();
      months = ((remaining.inDays % 365.25) / 30.44).floor();
      days = remaining.inDays % 30;
      hours = remaining.inHours % 24;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF0f3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header
            const Row(
              children: [
                Text(
                  'Life Clock ⏳',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Countdown Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  _buildTimeCard('Years', years.toString()),
                  _buildTimeCard('Months', months.toString()),
                  _buildTimeCard('Days', days.toString()),
                  _buildTimeCard('Hours', hours.toString()),
                ],
              ),
            ),
            
            // Progress Bar
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00d4ff)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${(progress * 100).toInt()}% lived',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Quote
            Text(
              quote,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF00d4ff),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}