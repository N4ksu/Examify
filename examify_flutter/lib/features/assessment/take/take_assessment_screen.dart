import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/proctoring/proctoring_service.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/violation_banner.dart';

class TakeAssessmentScreen extends ConsumerStatefulWidget {
  final String assessmentId;
  const TakeAssessmentScreen({super.key, required this.assessmentId});

  @override
  ConsumerState<TakeAssessmentScreen> createState() =>
      _TakeAssessmentScreenState();
}

class _TakeAssessmentScreenState extends ConsumerState<TakeAssessmentScreen> {
  late ProctoringService _proctoringService;
  int _violationCount = 0;

  int _currentQuestionIndex = 0;
  final int _timeLeft = 3600;

  @override
  void initState() {
    super.initState();
    _initProctoring();
  }

  void _initProctoring() {
    _proctoringService = ProctoringService(
      attemptId: 1,
      apiClient: ref.read(apiClientProvider),
      onViolation: (action) {
        if (!mounted) return;
        setState(() {
          _violationCount = _proctoringService.violationCount;
        });

        if (action == ProctoringAction.warn ||
            action == ProctoringAction.finalWarn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '⚠️ Warning: Focus loss detected. Please stay on the exam screen.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (action == ProctoringAction.autoSubmitted) {
          _submit(autoSubmit: true);
        }
      },
    );
    _proctoringService.start();
  }

  @override
  void dispose() {
    _proctoringService.stop();
    super.dispose();
  }

  void _submit({bool autoSubmit = false}) async {
    await _proctoringService.stop();
    if (!mounted) return;
    context.pushReplacement('/assessment/${widget.assessmentId}/result');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Assessment ${widget.assessmentId} - Proctored'),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Time Left: ${_timeLeft ~/ 60}:${(_timeLeft % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (_violationCount > 0)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ViolationBanner(violationCount: _violationCount),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'What is the speed of light in vacuum?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      RadioListTile(
                        title: const Text('299,792,458 m/s'),
                        value: 0,
                        groupValue: 0,
                        onChanged: (val) {},
                      ),
                      RadioListTile(
                        title: const Text('300,000,000 m/s'),
                        value: 1,
                        groupValue: 0,
                        onChanged: (val) {},
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton(
                            text: 'Previous',
                            onPressed: _currentQuestionIndex > 0
                                ? () => setState(() => _currentQuestionIndex--)
                                : () {},
                            isSecondary: true,
                          ),
                          AppButton(
                            text: 'Submit Assessment',
                            onPressed: () => _submit(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
