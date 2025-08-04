import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditActivityScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> existingData;

  const EditActivityScreen({
    super.key,
    required this.docId,
    required this.existingData,
  });

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  late TextEditingController typeController;
  late TextEditingController durationController;
  late TextEditingController caloriesController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController(text: widget.existingData['type']);
    durationController = TextEditingController(
      text: widget.existingData['duration'].toString(),
    );
    caloriesController = TextEditingController(
      text: widget.existingData['calories'].toString(),
    );
  }

  void saveChanges() async {
    setState(() => isSaving = true);
    await FirebaseFirestore.instance
        .collection('activities')
        .doc(widget.docId)
        .update({
          'type': typeController.text,
          'duration': int.tryParse(durationController.text) ?? 0,
          'calories': int.tryParse(caloriesController.text) ?? 0,
        });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Activity"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: "Activity Type"),
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: "Duration (min)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(labelText: "Calories Burned"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaving ? null : saveChanges,
              child:
                  isSaving ? CircularProgressIndicator() : Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
