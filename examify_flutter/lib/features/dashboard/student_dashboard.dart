import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800)
            Container(
              width: 250,
              color: Theme.of(context).colorScheme.surface,
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.class_),
                    title: const Text('My Classes'),
                    onTap: () {},
                    selected: true,
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () => context.push('/profile'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: 2,
              itemBuilder: (context, index) {
                return AppCard(
                  onTap: () => context.push('/classroom/${index + 1}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Joined Class ${index + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Teacher: Mr. Smith',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showJoinClassroomDialog(context),
        icon: const Icon(Icons.login),
        label: const Text('Join Classroom'),
      ),
    );
  }

  void _showJoinClassroomDialog(BuildContext context) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Classroom'),
        content: AppTextField(
          controller: codeController,
          label: 'Classroom Code',
          hint: 'Enter the code provided by your teacher',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Join',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
