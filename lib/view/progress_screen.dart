import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker_app/view/exportFile_screen.dart';
import 'package:fitness_tracker_app/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'edit_activity_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RxString selectedType = "All".obs;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    List<String> activityTypes = ["All", "Running", "Cycling", "Walking"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Progress"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExportScreen()),
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('activities')
                  .orderBy('date', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return Text("No data.");

            final Map<String, int> caloriesPerDay = {};
            final Map<String, List<QueryDocumentSnapshot>> grouped = {};

            for (var doc in docs) {
              final data = doc.data() as Map<String, dynamic>;
              final dateTime = DateTime.parse(data['date']);
              final formattedDate = DateFormat.yMMMMd().format(dateTime);
              grouped.putIfAbsent(formattedDate, () => []);
              grouped[formattedDate]!.add(doc);
              caloriesPerDay[DateFormat.yMd().format(dateTime)] =
                  (caloriesPerDay[DateFormat.yMd().format(dateTime)] ?? 0) +
                  (data['calories'] as num).toInt();
            }

            final dateKeys = grouped.keys.toList();

            return ListView(
              children: [
                Text(
                  "Calories Burned (per day)",
                  style: TextStyle(fontSize: 16),
                ),
                CaloriesBarChart(data: caloriesPerDay),
                Obx(
                  () => DropdownButton<String>(
                    value: selectedType.value,
                    items:
                        activityTypes
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) => selectedType.value = val ?? "All",
                  ),
                ),
                ...dateKeys.map((date) {
                  final dayActivities = grouped[date]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
                      ...dayActivities.map((act) {
                        final data = act.data() as Map<String, dynamic>;
                        if (selectedType.value != "All" &&
                            data['type'] != selectedType.value)
                          return SizedBox();
                        return Dismissible(
                          key: Key(act.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) async {
                            final deletedDoc = Map<String, dynamic>.from(
                              data,
                            ); // Backup
                            await FirebaseFirestore.instance
                                .collection('activities')
                                .doc(act.id)
                                .delete();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Activity deleted'),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('activities')
                                        .doc(act.id)
                                        .set(deletedDoc);
                                  },
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text("${data['type']}"),
                              subtitle: Text(
                                "${data['duration']} min | ${data['calories']} cal",
                              ),
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => EditActivityScreen(
                                            docId: act.id,
                                            existingData: data,
                                          ),
                                    ),
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
