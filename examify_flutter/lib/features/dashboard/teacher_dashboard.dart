import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_card.dart';

class TeacherDashboard extends ConsumerWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
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
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Classrooms'),
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
              itemCount: 3,
              itemBuilder: (context, index) {
                return AppCard(
                  onTap: () => context.push('/classroom/${index + 1}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Classroom ${index + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Code: XYZ${index}123',
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
        onPressed: () {
          // Dialog to create classroom
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Classroom'),
      ),
    );
  }
}
