import 'package:flutter/material.dart';
import '../../../shared/widgets/app_card.dart';

class ProctoringReportScreen extends StatelessWidget {
  final String assessmentId;
  const ProctoringReportScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proctoring Report - Assessment $assessmentId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Alerts',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Total violations detected: 3'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AppCard(
                padding: EdgeInsets.zero,
                child: ListView(
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Student')),
                        DataColumn(label: Text('Event Type')),
                        DataColumn(label: Text('Platform')),
                        DataColumn(label: Text('Time')),
                      ],
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(Text('John Doe')),
                            DataCell(Text('window_blur')),
                            DataCell(Text('Windows 11')),
                            DataCell(Text('10:45 AM')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Jane Smith')),
                            DataCell(Text('app_background')),
                            DataCell(Text('iOS 16')),
                            DataCell(Text('11:02 AM')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('John Doe')),
                            DataCell(Text('window_blur')),
                            DataCell(Text('Windows 11')),
                            DataCell(Text('11:15 AM')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
