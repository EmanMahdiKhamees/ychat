<?php

namespace App\Http\Controllers;

use App\Models\Message;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function index()
    {
        return Message::with('user')->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'text' => 'required|string',
        ]);

        $message = Message::create($request->only('user_id', 'text'));
        return response()->json($message->load('user'), 201);
    }
}
