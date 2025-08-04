import 'package:fitness_tracker_app/view/progress_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String type = '';
  int duration = 0;
  int calories = 0;
  bool _isLoading = false;

  void saveToFirebase() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('activities').add({
        'type': type,
        'duration': duration,
        'calories': calories,
        'date': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print(
          "Activity saved: $type, Duration: $duration, Calories: $calories",
        );
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("🎉 Activity saved!")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProgressScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving activity: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Activity"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            color: Colors.deepPurple.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Log New Activity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 28 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      label: "Type (e.g., Running)",
                      icon: Icons.directions_run,
                      onSaved: (val) => type = val ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "Duration (minutes)",
                      icon: Icons.timer,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => duration = int.tryParse(val ?? '') ?? 0,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "Calories Burned",
                      icon: Icons.local_fire_department,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => calories = int.tryParse(val ?? '') ?? 0,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                _formKey.currentState?.save();
                                saveToFirebase();
                              },
                      child:
                          _isLoading
                              ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(width: 8),
                                  Text(
                                    "Save Activity",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                    ),

                    const SizedBox(height: 12),
                    TextButton.icon(
                      icon: Icon(Icons.bar_chart),
                      label: Text("View Progress"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgressScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
    );
  }
}
