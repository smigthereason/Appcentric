<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Subject;
use Illuminate\Http\Request;

class SubjectController extends Controller
{
    public function index()
    {
        $subjects = Subject::withCount('papers')
            ->orderBy('name')
            ->paginate(10);

        return response()->json($subjects);
    }
}
