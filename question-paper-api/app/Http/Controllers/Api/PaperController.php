<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Paper;
use App\Models\Subject;
use Illuminate\Http\Request;

class PaperController extends Controller
{
    public function index(Request $request)
    {
        $query = Paper::with(['subject', 'questions.answers']);

        // Filter by subject and year
        if ($request->has('subject') && $request->has('year')) {
            $subject = Subject::where('code', $request->subject)->first();
            
            if ($subject) {
                $query->where('subject_id', $subject->id)
                      ->where('year', $request->year);
            }
        }

        // Search functionality
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhereHas('subject', function($q) use ($search) {
                      $q->where('name', 'like', "%{$search}%")
                        ->orWhere('code', 'like', "%{$search}%");
                  });
            });
        }

        $papers = $query->orderBy('year', 'desc')
                       ->paginate(15);

        return response()->json($papers);
    }

    public function show($id)
    {
        $paper = Paper::with(['subject', 'questions.answers'])
                     ->findOrFail($id);

        return response()->json($paper);
    }
}
