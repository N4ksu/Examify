import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'announcements_tab.dart';
import 'assessments_tab.dart';

class ClassroomDetailScreen extends ConsumerWidget {
  final String id;
  const ClassroomDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Classroom $id'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Announcements'),
              Tab(text: 'Assessments'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AnnouncementsTab(classroomId: id),
            AssessmentsTab(classroomId: id),
          ],
        ),
      ),
    );
  }
}
