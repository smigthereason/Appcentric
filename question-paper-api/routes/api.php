<?php

use Illuminate\Support\Facades\Route;

// Test route
Route::get("/publicum", function () {
    return response()->json(["message" => "API is working!", "data" => []]);
});

Route::post("/auth/login", function () {
    return response()->json(["token" => "test-token", "user" => ["name" => "Test User"]]);
});