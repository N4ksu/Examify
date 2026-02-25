<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\StudentAttempt;
use App\Models\Assessment;
use App\Models\User;

class ResultController extends Controller
{
    public function studentResult(Request $request, $id)
    {
        $attempt = StudentAttempt::with(['assessment.questions.options', 'answers'])
            ->findOrFail($id);

        if ($attempt->student_id !== $request->user()->id) {
            abort(403);
        }

        $totalQuestions = $attempt->assessment->questions->count();
        $percentage = $totalQuestions > 0 ? ($attempt->score / $totalQuestions) * 100 : 0;

        $answers = $attempt->assessment->questions->map(function ($question) use ($attempt) {
            $studentAnswer = $attempt->answers->where('question_id', $question->id)->first();
            $correctOption = $question->options->where('is_correct', true)->first();
            $selectedOption = $studentAnswer && $studentAnswer->option_id ? $question->options->where('id', $studentAnswer->option_id)->first() : null;

            return [
                'question' => $question->body,
                'your_answer' => $selectedOption ? $selectedOption->body : 'No answer',
                'correct_answer' => $correctOption ? $correctOption->body : 'N/A',
                'is_correct' => $selectedOption ? $selectedOption->is_correct : false,
            ];
        });

        return response()->json([
            'score' => $attempt->score,
            'total' => $totalQuestions,
            'percentage' => round($percentage, 2),
            'status' => $attempt->status,
            'answers' => $answers,
        ], 200);
    }

    public function teacherResults(Request $request, $id)
    {
        $assessment = Assessment::findOrFail($id);

        if ($assessment->classroom->teacher_id !== $request->user()->id) {
            abort(403);
        }

        $totalQuestions = $assessment->questions()->count();

        $results = StudentAttempt::where('assessment_id', $id)
            ->with('student:id,name,email')
            ->get()
            ->map(function ($attempt) use ($totalQuestions) {
                return [
                    'student' => $attempt->student,
                    'score' => $attempt->score,
                    'total' => $totalQuestions,
                    'status' => $attempt->status,
                    'violation_count' => $attempt->violation_count,
                    'submitted_at' => $attempt->submitted_at ? $attempt->submitted_at->toIso8601String() : null,
                ];
            });

        return response()->json($results, 200);
    }

    public function proctoringReport(Request $request, $id)
    {
        $assessment = Assessment::findOrFail($id);

        if ($assessment->classroom->teacher_id !== $request->user()->id) {
            abort(403);
        }

        $reports = StudentAttempt::where('assessment_id', $id)
            ->with([
                'student:id,name,email',
                'proctoringLogs' => function ($query) {
                    $query->orderBy('violation_number', 'asc');
                }
            ])
            ->get()
            ->map(function ($attempt) {
                return [
                    'student' => $attempt->student,
                    'total_violations' => $attempt->violation_count,
                    'logs' => $attempt->proctoringLogs->map(function ($log) {
                        return [
                            'event_type' => $log->event_type,
                            'platform' => $log->platform,
                            'device_info' => $log->device_info,
                            'ip_address' => $log->ip_address,
                            'violation_number' => $log->violation_number,
                            'timestamp' => $log->timestamp->toIso8601String(),
                        ];
                    }),
                ];
            });

        return response()->json($reports, 200);
    }
}
