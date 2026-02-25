import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/classroom_provider.dart';

class PeopleTab extends ConsumerWidget {
  final String classroomId;
  const PeopleTab({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(classroomStudentsProvider(classroomId));
    final classroomAsync = ref.watch(classroomDetailProvider(classroomId));

    return classroomAsync.when(
      data: (classroom) => studentsAsync.when(
        data: (students) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: [
            _buildSectionHeader(context, 'Teachers', Icons.person_add_alt_1),
            _buildPersonRow(
              context,
              classroom.teacher?.name ?? 'Teacher',
              isTeacher: true,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(
              context,
              'Classmates',
              Icons.person_add_alt_1,
              count: students.length,
            ),
            ...students.map((s) => _buildPersonRow(context, s.name)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error students: $err')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error classroom: $err')),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    int? count,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (count != null)
              Text(
                '$count students',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(width: 8),
            Icon(icon, color: Theme.of(context).colorScheme.primary),
          ],
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget _buildPersonRow(
    BuildContext context,
    String name, {
    bool isTeacher = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(width: 16),
          Text(name, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
