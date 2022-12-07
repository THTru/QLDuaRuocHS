<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\GeneralController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\ParentController;
use App\Http\Controllers\CarerController;

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
Route::get('/users/type', [GeneralController::class, 'usersbyType']);

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

Route::get('registrations', [GeneralController::class, 'registrations']);
Route::get('registration', [GeneralController::class, 'registration']);

Route::get('studenttrips', [GeneralController::class, 'studenttrips']);
Route::get('studenttrips/date', [GeneralController::class, 'studenttripsbyDate']);
Route::get('studenttrips/trip', [GeneralController::class, 'studenttripsbyTrip']);

Route::get('dayoffs', [GeneralController::class, 'dayoffs']);

//Auth API
Route::post('login2', [AuthController::class, 'login2']);
Route::post('authcheck', [AuthController::class, 'authcheck']);
Route::post('login', [AuthController::class, 'login']);

//AuthTest
Route::post('register', [AuthController::class, 'register']);
Route::post('login2', [AuthController::class, 'login2']);
Route::post('logout2', [AuthController::class, 'logout2']);
Route::get('user2', [AuthController::class, 'user2']);

//Admin API
Route::group(['middleware' => 'auth.admin'], function(){

Route::post('newUser', [AdminController::class, 'newUser']); //Tạo người dùng mới
Route::patch('editUser', [AdminController::class, 'editUser']); //Sửa thông tin người dùng
Route::patch('changePassword', [AdminController::class, 'changePassword']); //Đổi mật khẩu người dùng
Route::delete('deleteUser', [AdminController::class, 'deleteUser']); //Xóa người dùng

Route::post('newClass', [AdminController::class, 'newClass']); //Tạo lớp học mới
Route::patch('editClass', [AdminController::class, 'editClass']); //Đổi tên lớp
Route::delete('deleteClass', [AdminController::class, 'deleteClass']); //Xóa lớp

Route::post('newStudent', [AdminController::class, 'newStudent']); //Tạo học sinh mới
Route::patch('editStudent', [AdminController::class, 'editStudent']); //Sửa thông tin học sinh
Route::patch('bondParentStudent', [AdminController::class, 'bondParentStudent']); //Liên kết phụ huynh với học sinh
Route::delete('deleteStudent', [AdminController::class, 'deleteStudent']); //Xóa học sinh


Route::post('newVehicle', [AdminController::class, 'newVehicle']); //Tạo xe mới
Route::patch('editVehicle', [AdminController::class, 'editVehicle']); //Sửa thông tin xe
Route::delete('deleteVehicle', [AdminController::class, 'deleteVehicle']); //Xóa xe

Route::post('newDriver', [AdminController::class, 'newDriver']); //Tạo tài xế mới
Route::patch('editDriver', [AdminController::class, 'editDriver']); //Sửa thông tin tài xế
Route::delete('deleteDriver', [AdminController::class, 'deleteDriver']); //Xóa tài xế

Route::post('newStop', [AdminController::class, 'newStop']); //Tạo điểm dừng mới
Route::patch('editStop', [AdminController::class, 'editStop']); //chỉnh sửa điểm dừng mới
Route::delete('deleteStop', [AdminController::class, 'deleteStop']); //Xóa điểm dừng

Route::post('newSchedule', [AdminController::class, 'newSchedule']); //Tạo lịch trình mới
Route::patch('editSchedule', [AdminController::class, 'editSchedule']); //Sửa tên và mô tả lịch trình
Route::delete('deleteSchedule', [AdminController::class, 'deleteSchedule']); //Xóa lịch trình

Route::post('newLineType', [AdminController::class, 'newLineType']); //Tạo loại tuyến mới
Route::patch('editLineType', [AdminController::class, 'editLineType']); //Sửa thông tin loại tuyến
Route::delete('deleteLineType', [AdminController::class, 'deleteLineType']); //Xóa loại tuyến

Route::post('newLine', [AdminController::class, 'newLine']); //Tạo tuyến mới
Route::patch('editLine', [AdminController::class, 'editLine']); //Sửa thông tin tuyến
Route::patch('changeLineStatus', [AdminController::class, 'changeLineStatus']); //Chuyển trạng thái tuyến
Route::delete('deleteLine', [AdminController::class, 'deleteLine']); //Xóa tuyến

Route::post('newDayOff', [AdminController::class, 'newDayOff']); //Taọ ngày nghỉ mới
Route::patch('editDayOff', [AdminController::class, 'editDayOff']); //Sửa thông tin ngày nghỉ
Route::delete('deleteDayOff', [AdminController::class, 'deleteDayOff']); //Xóa ngày nghỉ

Route::post('createTrips', [AdminController::class, 'createTrips']); //Tạo các chuyến theo tuyến
Route::patch('editTrip', [AdminController::class, 'editTrip']); //Sửa thông tin chuyến

});
//Parent API
Route::group(['middleware' => 'auth.parent'], function(){

Route::post('regLine', [ParentController::class, 'regLine']); //Đăng ký
Route::delete('cancelRegLine', [ParentController::class, 'cancelRegLine']); //Đăng ký

Route::patch('requestAbsence', [ParentController::class, 'requestAbsence']); //Xin phép học sinh không tham gia chuyến

});

//Carer API
Route::group(['middleware' => 'auth.carer'], function(){

Route::patch('startTrip', [CarerController::class, 'startTrip']); //Bắt đầu chuyến
Route::patch('endTrip', [CarerController::class, 'endTrip']); //Kết thúc chuyến

Route::patch('checkOnStudentTrip', [CarerController::class, 'checkOnStudentTrip']); //Điểm danh học sinh lên xe
Route::patch('checkOffStudentTrip', [CarerController::class, 'checkOffStudentTrip']); //Điểm danh học sinh xuống xe
Route::patch('checkAbsenceStudentTrip', [CarerController::class, 'checkAbsenceStudentTrip']); //Điểm danh học sinh vắng

});