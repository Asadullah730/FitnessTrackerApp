import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ExportScreen extends StatefulWidget {
  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool isExporting = false;

  Future<void> exportCSV() async {
    setState(() => isExporting = true);

    try {
      // Ask for storage permission
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          // permission granted, continue
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Permission denied')));
          setState(() => isExporting = false);
          return;
        }
      }

      // Fetch activities
      final snapshot =
          await FirebaseFirestore.instance
              .collection('activities')
              .orderBy('date', descending: true)
              .get();

      final rows = [
        ["Type", "Duration (min)", "Calories", "Date"],
      ];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        rows.add([
          data['type'],
          data['duration'].toString(),
          data['calories'].toString(),
          data['date'].toString(),
        ]);
      }

      // Convert to CSV
      final csv = const ListToCsvConverter().convert(rows);

      // Get file path
      final directory =
          await getApplicationDocumentsDirectory(); // No permission needed

      final path = "${directory!.path}/fitness_export.csv";
      final file = File(path);

      await file.writeAsString(csv);

      // Share or save
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Here is your activity export 📊');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("CSV exported to: $path")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error exporting CSV: $e")));
      if (kDebugMode) {
        print("ERROR : $e");
      }
    } finally {
      setState(() => isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Export Progress"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child:
            isExporting
                ? CircularProgressIndicator(color: Colors.deepPurple)
                : ElevatedButton.icon(
                  onPressed: exportCSV,
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text(
                    "Export CSV",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[400],
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
      ),
    );
  }
}
