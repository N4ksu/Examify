import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/providers/classroom_provider.dart';
import '../../shared/models/classroom.dart';
import '../../shared/models/announcement.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_button.dart';

class StreamTab extends ConsumerWidget {
  final String classroomId;
  const StreamTab({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isTeacher = user?.role.name == 'teacher';

    final classroomAsync = ref.watch(classroomDetailProvider(classroomId));
    final announcementsAsync = ref.watch(announcementsProvider(classroomId));

    return Scaffold(
      body: classroomAsync.when(
        data: (classroom) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Banner Section
              _buildBanner(context, classroom, isTeacher, ref),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Meet & Upcoming (Desktop/Tablet)
                  if (MediaQuery.of(context).size.width > 800)
                    SizedBox(
                      width: 250,
                      child: Column(
                        children: [
                          _buildMeetCard(context, isTeacher),
                          const SizedBox(height: 16),
                          _buildUpcomingCard(context),
                        ],
                      ),
                    ),

                  const SizedBox(width: 24),

                  // Right Column: Announcements
                  Expanded(
                    child: Column(
                      children: [
                        _buildAnnouncementInput(context, isTeacher, ref),
                        const SizedBox(height: 16),
                        announcementsAsync.when(
                          data: (announcements) => _buildAnnouncementList(
                            context,
                            isTeacher,
                            announcements,
                            ref,
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) =>
                              Center(child: Text('Error: $err')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBanner(
    BuildContext context,
    Classroom classroom,
    bool isTeacher,
    WidgetRef ref,
  ) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: const AssetImage('assets/classroom_banner_it312.png'),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) => {},
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                classroom.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (classroom.description != null)
                Text(
                  classroom.description!,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
            ],
          ),
          if (isTeacher)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () =>
                    _showEditClassroomDialog(context, classroom, ref),
              ),
            ),
        ],
      ),
    );
  }

  void _showEditClassroomDialog(
    BuildContext context,
    Classroom classroom,
    WidgetRef ref,
  ) {
    final nameController = TextEditingController(text: classroom.name);
    final descController = TextEditingController(text: classroom.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Classroom Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: nameController, label: 'Classroom Name'),
            const SizedBox(height: 16),
            AppTextField(
              controller: descController,
              label: 'Schedule/Description',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Save',
            onPressed: () async {
              try {
                await ClassroomActions(ref).updateClassroom(
                  classroom.id,
                  nameController.text,
                  descController.text,
                );
                Navigator.pop(context);
                ref.invalidate(classroomDetailProvider(classroomId));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update classroom: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMeetCard(BuildContext context, bool isTeacher) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                'https://www.gstatic.com/meet/google_meet_primary_horizontal_2020q4_logo_be3f850c950486c9da5eb65dd07165.png',
                height: 20,
              ),
              const Spacer(),
              if (isTeacher)
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(maxWidth: 150),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'settings',
                      child: Text('Manage link'),
                    ),
                    const PopupMenuItem(
                      value: 'copy',
                      child: Text('Copy link'),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () =>
                  context.push('/classroom/$classroomId/meet-prep'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Join'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          Text(
            'Woohoo, no work due soon!',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () {}, child: const Text('View all')),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementInput(
    BuildContext context,
    bool isTeacher,
    WidgetRef ref,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isTeacher
                  ? 'Announce something to your class'
                  : 'Communicate with your class',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      onTap: () => _showPostAnnouncementDialog(context, isTeacher, ref),
    );
  }

  void _showPostAnnouncementDialog(
    BuildContext context,
    bool isTeacher,
    WidgetRef ref, {
    Announcement? announcement,
  }) {
    final titleController = TextEditingController(
      text: announcement != null ? 'Update' : '',
    );
    final bodyController = TextEditingController(
      text: announcement?.body ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          announcement != null
              ? 'Edit Announcement'
              : (isTeacher ? 'Post Announcement' : 'Write a comment'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isTeacher)
              AppTextField(
                controller: titleController,
                label: 'Title',
                hint: 'e.g. Important Update',
              ),
            const SizedBox(height: 16),
            AppTextField(
              controller: bodyController,
              label: 'Message',
              hint: 'What\'s on your mind?',
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
            text: announcement != null ? 'Save' : 'Post',
            onPressed: () async {
              if (bodyController.text.isEmpty) return;

              try {
                final actions = AnnouncementActions(ref, classroomId);
                if (announcement != null) {
                  await actions.update(
                    announcement.id,
                    titleController.text,
                    bodyController.text,
                  );
                } else {
                  await actions.create(
                    titleController.text.isEmpty
                        ? 'Class Update'
                        : titleController.text,
                    bodyController.text,
                  );
                }
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Failed to post: $e')));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementList(
    BuildContext context,
    bool isTeacher,
    List<Announcement> announcements,
    WidgetRef ref,
  ) {
    if (announcements.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No announcements yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final ann = announcements[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(child: Text(ann.teacher?.name[0] ?? '?')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: '${ann.teacher?.name ?? 'Teacher'} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ann.title),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy').format(ann.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (isTeacher)
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            _showPostAnnouncementDialog(
                              context,
                              isTeacher,
                              ref,
                              announcement: ann,
                            );
                          } else if (value == 'delete') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Announcement'),
                                content: const Text(
                                  'Are you sure you want to delete this announcement?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await AnnouncementActions(
                                ref,
                                classroomId,
                              ).delete(ann.id);
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(ann.body),
              ],
            ),
          ),
        );
      },
    );
  }
}
