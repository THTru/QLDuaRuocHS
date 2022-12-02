<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    
    // public function login(Request $req){ //email, password, type
    //     //kiểm tra
    //     $rules = [
    //         'email' =>'required',
    //         'password' => 'required',
    //         'type' => 'required',
    //     ];
    //     $validator = Validator::make($req->all(), $rules);
    //     if($validator->fails()){
    //         return response()->json($validator->errors(), 400);
    //     }
    //     $user = User::where('email', $req->email)->first();
    //     if($user != NULL && $req->type == $user->type && $user->password == $req->password){
    //         $response = [ 'message' => 'OK' ];
    //         return response()->json($response, 200);
    //     }
    //     $response = [ 'message' => 'Sai email hoặc mật khẩu' ];
    //     return response()->json($response, 400);
    // }

    public function login()
    {
        $credentials = request(['email', 'password']);

        if (! $token = auth()->attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        return $this->respondWithToken($token);
    }

    protected function respondWithToken($token)
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => 3600
        ]);
    }

    public function login2(Request $req){
        $rules = [
            'email' =>'required',
            'password' => 'required',
            'type' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 430);
        }
        // if(Auth::attempt(['email' => $req->email, 'password' => $req->password], true)){
        //     $token = Auth::user()->createToken('Personal Access Token')->plainTextToken;
        //     $response = [ 'user' => Auth::user(), 'token' =>$token ];
        //     return response()->json($response, 200);
        // }
        $user = User::where('email', $req->email)->with('student')->first();
        if($user->type != $req->type){
            return response()->json([ 'message' => 'Sai email hoặc mật khẩu'], 430);
        }

        if ($token = auth()->attempt(request(['email', 'password']))) {
            return response()->json(['token' => $token, 'user' => $user ], 200);
        }
        $response = [ 'message' => 'Sai email hoặc mật khẩu' ];
        return response()->json($response, 430);
    }

    public function authcheck(Request $req){
        $response = [ 'message' => 'Oke' ];
        if(Auth::check())
        return response()->json($response, 200);
        else {
            $response = [ 'message' => 'Chưa đăng nhập' ];
            return response()->json($response, 430);
        }
    }

    public function logout2(Request $req){
        auth()->logout();
        $response = [ 'message' => 'Logout thành công' ];
        return response()->json($response, 200);
    }

    public function user2(Request $req){
        // $response = [ 'user' => Auth::user() ];
        // return response()->json($response, 200);
        return Auth::check();
    }

    public function register(Request $req){
        $rules = [
            'email' =>'required|string|unique:users',
            'password' => 'required|string|min:6',
            'name' => 'required|string',
            'type' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 400);
        }
        $user = User::create([
            'email' => $req->email,
            'password' => Hash::make($req->password),
            'name' => $req->name,
            'type' => $req->type,
        ]);
        $response = ['user' => User::latest()->first()];
        return response()->json($response, 200);
    }
}
