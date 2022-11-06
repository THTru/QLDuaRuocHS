<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\GeneralController;
use App\Http\Controllers\AuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

//General API
Route::get('/test', [GeneralController::class, 'test']);

Route::get('/users', [GeneralController::class, 'users']);

Route::get('/classes', [GeneralController::class, 'classes']);
Route::get('/class', [GeneralController::class, 'class']);

Route::get('/students', [GeneralController::class, 'students']);
Route::get('/students/name', [GeneralController::class, 'studentsbyName']);
Route::get('/students/parent', [GeneralController::class, 'studentsbyParent']);
Route::get('/students/class', [GeneralController::class, 'studentsbyClass']);
Route::get('/student', [GeneralController::class, 'student']);

Route::get('/drivers', [GeneralController::class, 'drivers']);
Route::get('/drivers/name', [GeneralController::class, 'driversbyName']);
Route::get('/driver', [GeneralController::class, 'driver']);

Route::get('/vehicles', [GeneralController::class, 'vehicles']);
Route::get('/vehicles/number', [GeneralController::class, 'vehiclesbyNumber']);
Route::get('/vehicle', [GeneralController::class, 'vehicle']);

Route::get('/stops', [GeneralController::class, 'stops']);
Route::get('/stops/name', [GeneralController::class, 'stopsbyName']);
Route::get('/stops/district', [GeneralController::class, 'stopsbyDistrict']);
Route::get('/stops/ward', [GeneralController::class, 'stopsbyWard']);
Route::get('/stop', [GeneralController::class, 'stop']);

Route::get('/schedules', [GeneralController::class, 'schedules']);
Route::get('/schedules/name', [GeneralController::class, 'schedulesbyName']);
Route::get('/schedule', [GeneralController::class, 'schedule']);

Route::get('linetypes', [GeneralController::class, 'linetypes']);
Route::get('linetypes/filter', [GeneralController::class, 'linetypesFilter']);
Route::get('linetype', [GeneralController::class, 'linetype']);

Route::get('lines', [GeneralController::class, 'lines']);
Route::get('lines/filter', [GeneralController::class, 'linesFilter']);
Route::get('line', [GeneralController::class, 'line']);

Route::get('trips', [GeneralController::class, 'trips']);
Route::get('trips/filter', [GeneralController::class, 'tripsFilter']);
Route::get('trip', [GeneralController::class, 'trip']);

//Auth API
Route::post('login', [AuthController::class, 'login']);

//AuthTest
Route::post('register', [AuthController::class, 'register']);
Route::post('login2', [AuthController::class, 'login2']);
Route::post('logout2', [AuthController::class, 'logout2']);
Route::get('user2', [AuthController::class, 'user2']);