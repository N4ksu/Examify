import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_card.dart';

class AssessmentsTab extends ConsumerWidget {
  final String classroomId;
  const AssessmentsTab({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isTeacher = user?.role.name == 'teacher';

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildAssignmentSection(context, 'Assessments'),
          _buildAssignmentItem(
            context,
            'Midterm Exam',
            'Posted Feb 12',
            Icons.assignment,
            isTeacher: isTeacher,
            status: isTeacher ? '3 turned in' : 'Assigned',
            onTap: () => context.push(
              isTeacher ? '/assessment/1/reports' : '/assessment/1/consent',
            ),
          ),
          _buildAssignmentItem(
            context,
            'Weekly Quiz #1',
            'Posted Feb 10',
            Icons.assignment,
            isTeacher: isTeacher,
            status: isTeacher ? '25 turned in' : 'Turned in',
            onTap: () => context.push(
              isTeacher ? '/assessment/2/reports' : '/assessment/2/consent',
            ),
          ),
          const SizedBox(height: 32),
          _buildAssignmentSection(context, 'Quizzes'),
          _buildAssignmentItem(
            context,
            'Prelim Lab Exam Grade',
            'Posted Feb 12',
            Icons.assignment_turned_in,
            isTeacher: isTeacher,
            status: isTeacher ? 'View grades' : 'Graded: 95/100',
            onTap: () {},
          ),
        ],
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton.extended(
              onPressed: () =>
                  context.push('/classroom/$classroomId/create-assessment'),
              icon: const Icon(Icons.add),
              label: const Text('Create'),
            )
          : null,
    );
  }

  Widget _buildAssignmentSection(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Divider(thickness: 1, height: 24),
      ],
    );
  }

  Widget _buildAssignmentItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    required bool isTeacher,
    String? status,
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (status != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          if (isTeacher)
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            )
          else
            const Icon(Icons.more_vert, size: 20),
        ],
      ),
    );
  }
}
