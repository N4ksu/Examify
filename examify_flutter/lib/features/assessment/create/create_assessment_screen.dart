import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class CreateAssessmentScreen extends StatefulWidget {
  final String classroomId;
  const CreateAssessmentScreen({super.key, required this.classroomId});

  @override
  State<CreateAssessmentScreen> createState() => _CreateAssessmentScreenState();
}

class _CreateAssessmentScreenState extends State<CreateAssessmentScreen> {
  final _titleController = TextEditingController();
  final _timeLimitController = TextEditingController(text: '60');
  String _type = 'exam';

  void _save() {
    // API call to save assessment
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Assessment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _titleController,
              label: 'Title',
              hint: 'e.g. Midterm Physics',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: const [
                DropdownMenuItem(value: 'exam', child: Text('Exam')),
                DropdownMenuItem(value: 'quiz', child: Text('Quiz')),
                DropdownMenuItem(value: 'activity', child: Text('Activity')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _type = val);
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _timeLimitController,
              label: 'Time Limit (Minutes)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            AppButton(text: 'Create Assessment', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
