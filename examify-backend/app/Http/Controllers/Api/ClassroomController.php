<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Classroom;
use Illuminate\Support\Str;

class ClassroomController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'teacher') {
            $classrooms = $user->classrooms()->withCount('students')->get();
        } else {
            $classrooms = $user->enrolledClassrooms()->with('teacher:id,name')->get();
        }

        return response()->json($classrooms, 200);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $joinCode = strtoupper(Str::random(6));
        while (Classroom::where('join_code', $joinCode)->exists()) {
            $joinCode = strtoupper(Str::random(6));
        }

        $classroom = $request->user()->classrooms()->create([
            'name' => $validated['name'],
            'description' => $validated['description'],
            'join_code' => $joinCode,
        ]);

        return response()->json(['classroom' => $classroom], 201);
    }

    public function join(Request $request, $id)
    {
        $validated = $request->validate([
            'join_code' => 'required|string|size:6',
        ]);

        $classroom = Classroom::findOrFail($id);

        if ($classroom->join_code !== strtoupper($validated['join_code'])) {
            return response()->json(['message' => 'Invalid join code'], 400);
        }

        if ($classroom->students()->where('student_id', $request->user()->id)->exists()) {
            return response()->json(['message' => 'Already joined'], 409);
        }

        $classroom->students()->attach($request->user()->id);

        return response()->json(['message' => 'Joined successfully'], 200);
    }

    public function students(Request $request, $id)
    {
        $classroom = Classroom::where('id', $id)->where('teacher_id', $request->user()->id)->firstOrFail();

        return response()->json($classroom->students, 200);
    }
}
