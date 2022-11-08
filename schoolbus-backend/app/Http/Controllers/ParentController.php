<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\Hclass;
use App\Models\Student;
use App\Models\Vehicle;
use App\Models\Driver;
use App\Models\Stop;
use App\Models\Schedule;
use App\Models\StopSchedule;
use App\Models\LineType;
use App\Models\Line;
use App\Models\Registration; // Register, Cancel
use App\Models\Trip;
use App\Models\StudentTrip;
use App\Models\User;

class ParentController extends Controller
{
    //=========================================== REGISTRATION ==============================================
    //Đăng ký tuyến cho học sinh
    public function regLine(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'parent_id' => 'required',
            'student_id' =>'required',
            'line_id' => 'required',
            'stop_id' => 'required'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $parent_id = $req->parent_id;
        $student_id = $req->student_id;
        $line_id = $req->line_id;
        $stop_id = $req->stop_id;

        $parent = User::find($parent_id);
        if($parent == NULL || $parent->type != 3){
            $response = [ 'message ' => 'Mã phụ huynh sai' ];
            return response()->json($response, 400);
        }
        $student = Student::find($student_id);
        if($student == NULL || $student->parent_id != $parent_id){
            $response = [ 'message ' => 'Sai thông tin học sinh' ];
            return response()->json($response, 400);
        }
        if(Line::find($line_id) == NULL || Line::find($line_id)->line_status != 1){
            $response = [ 'message ' => 'Không tìm thấy tuyến' ];
            return response()->json($response, 400);
        }
        if(Stop::find($stop_id) == NULL){
            $response = [ 'message ' => 'Không tìm thấy điểm dừng' ];
            return response()->json($response, 400);
        }

        $today = Carbon::now();
        $deadline = new Carbon(Line::find($line_id)->reg_deadline);
        if($today->gt($deadline)){
            $response = [ 'message ' => 'Quá thời hạn đăng ký' ];
            return response()->json($response, 400);
        }

        if(Registration::where('line_id', $line_id)->where('student_id', $student_id)->exists()){
            $response = [ 'message ' => 'Đã đăng ký tuyến này rồi' ];
            return response()->json($response, 400);
        }

        $countRegistered = Registration::where('line_id', $line_id)->get()->count();
        if($countRegistered >= Line::find($line_id)->slot){
            $response = [ 'message ' => 'Hết lượt đăng ký' ];
            return response()->json($response, 400);
        }

        $newRegistration = new Registration;
        $newRegistration->reg_time = $today;
        $newRegistration->student_id = $student_id;
        $newRegistration->line_id = $line_id;
        $newRegistration->stop_id = $stop_id;
        $newRegistration->save();
        return response()->json($response, 200);
    }

    //Hủy đăng ký
    public function cancelRegLine(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'parent_id' => 'required',
            'reg_id' => 'required'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $parent_id = $req->parent_id;
        $reg_id = $req->reg_id;

        $registration = Registration::find($reg_id);
        if($registration == NULL){
            $response = [ 'message ' => 'Không tìm thấy đăng ký' ];
            return response()->json($response, 400);
        }
        if($registration->student->first()->parent_id != $parent_id){
            $response = [ 'message ' => 'Không có quyền hủy đăng ký này' ];
            return response()->json($response, 400);
        }

        $registration->delete();

        return response()->json($response, 200);
    }
}
