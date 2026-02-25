import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

class AnnouncementsTab extends ConsumerWidget {
  final String classroomId;
  const AnnouncementsTab({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isTeacher = user?.role.name == 'teacher';

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 3, // Mock data
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Post title ${index + 1}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Oct 12, 2024',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is the content of announcement ${index + 1}. Please review the materials before the next assessment.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: () => _showPostAnnouncementDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showPostAnnouncementDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: titleController,
              label: 'Title',
              hint: 'Announcement Title',
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: contentController,
              label: 'Content',
              hint: 'Write your message here...',
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Post',
            onPressed: () {
              // Mock posting
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Announcement posted')),
              );
            },
          ),
        ],
      ),
    );
  }
}
