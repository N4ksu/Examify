import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stream_tab.dart';
import 'assessments_tab.dart'; // We'll keep this as ClassworkTab
import 'people_tab.dart';

class ClassroomDetailScreen extends ConsumerWidget {
  final String id;
  const ClassroomDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Classroom'),
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam_outlined),
              onPressed: () {},
            ),
            IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Stream'),
              Tab(text: 'Classwork'),
              Tab(text: 'People'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamTab(classroomId: id),
            AssessmentsTab(classroomId: id), // This is our 'Classwork' tab
            PeopleTab(classroomId: id),
          ],
        ),
      ),
    );
  }
}
