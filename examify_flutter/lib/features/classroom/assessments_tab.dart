import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_button.dart';

class AssessmentsTab extends ConsumerWidget {
  final String classroomId;
  const AssessmentsTab({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isTeacher = user?.role.name == 'teacher';

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 2, // Mock data
        itemBuilder: (context, index) {
          final isExam = index == 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExam ? 'Midterm Exam' : 'Weekly Quiz',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Type: ${isExam ? 'Exam' : 'Quiz'} | Time: ${isExam ? '120 min' : '30 min'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isTeacher) ...[
                    AppButton(
                      text: 'Reports',
                      onPressed: () => context.push('/assessment/1/reports'),
                      isSecondary: true,
                    ),
                  ] else ...[
                    AppButton(
                      text: 'Start',
                      onPressed: () => context.push('/assessment/1/consent'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton.extended(
              onPressed: () =>
                  context.push('/classroom/$classroomId/create-assessment'),
              icon: const Icon(Icons.add),
              label: const Text('Create Assessment'),
            )
          : null,
    );
  }
}
