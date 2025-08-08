import 'package:fitness_tracker_app/view/add_activity_screen.dart';
import 'package:fitness_tracker_app/view/exportFile_screen.dart';
import 'package:fitness_tracker_app/view/progress_screen.dart';
import 'package:fitness_tracker_app/widgets/chart.dart';
import 'package:fitness_tracker_app/widgets/route_transition_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          "Fitness Tracker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.deepPurple.shade400,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      "Welcome to Fitness Tracker!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Track your daily fitness, view progress and stay motivated!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Navigation buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _navButton(context, Icons.add, "Add Activity", () {
                  Navigator.pushReplacement(
                    context,
                    slideFadeRoute(AddActivityScreen()),
                  );
                }),
                _navButton(context, Icons.insights, "View Progress", () {
                  Navigator.pushReplacement(
                    context,
                    slideFadeRoute(ProgressScreen()),
                  );
                }),
                _navButton(context, Icons.file_download, "Export Data", () {
                  Navigator.pushReplacement(
                    context,
                    slideFadeRoute(ExportScreen()),
                  );
                }),
              ],
            ),

            SizedBox(height: 30),

            // Weekly goals
            Text("This Week's Goals", style: theme.textTheme.titleLarge),
            SizedBox(height: 10),
            _goalCard("Calories Burned", 0.65, "1300 / 2000 cal"),
            _goalCard("Workout Duration", 0.4, "80 / 200 mins"),
            CaloriesBarChart(data: {}),
          ],
        ),
      ),
    );
  }

  Widget _navButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _goalCard(String title, double percent, String subtitle) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 14.0,
              percent: percent,
              backgroundColor: Colors.grey.shade300,
              progressColor: Colors.deepPurple,
              barRadius: Radius.circular(10),
              animation: true,
            ),
            SizedBox(height: 6),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}
