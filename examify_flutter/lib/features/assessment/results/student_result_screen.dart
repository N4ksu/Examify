import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

class StudentResultScreen extends StatelessWidget {
  final String assessmentId;
  const StudentResultScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Result'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/student'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Assessment Submitted',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatScore(context, 'Score', '85%'),
                      _buildStatScore(context, 'Correct', '17/20'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    text: 'Return to Dashboard',
                    onPressed: () => context.go('/student'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatScore(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.displaySmall),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
