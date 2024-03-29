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
use App\Models\Registration; //Register, Cancel
use App\Models\Trip;
use App\Models\StudentTrip; //RequestAbsence
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
            return response()->json($response, 430);
        }

        $parent_id = $req->parent_id;
        $student_id = $req->student_id;
        $line_id = $req->line_id;
        $stop_id = $req->stop_id;

        $parent = User::find($parent_id);
        if($parent == NULL || $parent->type != 3){
            $response = [ 'message ' => 'Mã phụ huynh sai' ];
            return response()->json($response, 430);
        }
        $student = Student::find($student_id);
        if($student == NULL || $student->parent_id != $parent_id){
            $response = [ 'message ' => 'Sai thông tin học sinh' ];
            return response()->json($response, 430);
        }
        if(Line::find($line_id) == NULL || Line::find($line_id)->line_status != 1){
            $response = [ 'message ' => 'Không tìm thấy tuyến' ];
            return response()->json($response, 430);
        }
        if(Stop::find($stop_id) == NULL){
            $response = [ 'message ' => 'Không tìm thấy điểm dừng' ];
            return response()->json($response, 430);
        }

        $today = Carbon::now();
        $deadline = new Carbon(Line::find($line_id)->reg_deadline);
        if($today->gt($deadline)){
            $response = [ 'message ' => 'Quá thời hạn đăng ký' ];
            return response()->json($response, 430);
        }

        if(Registration::where('line_id', $line_id)->where('student_id', $student_id)->exists()){
            $response = [ 'message ' => 'Đã đăng ký tuyến này rồi' ];
            return response()->json($response, 430);
        }

        $countRegistered = Registration::where('line_id', $line_id)->get()->count();
        if($countRegistered >= Line::find($line_id)->slot){
            $response = [ 'message ' => 'Hết lượt đăng ký' ];
            return response()->json($response, 430);
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
            return response()->json($response, 430);
        }

        $parent_id = $req->parent_id;
        $reg_id = $req->reg_id;

        $registration = Registration::find($reg_id);
        if($registration == NULL){
            $response = [ 'message ' => 'Không tìm thấy đăng ký' ];
            return response()->json($response, 430);
        }
        if($registration->line->line_status != 1){
            $response = [ 'message ' => 'Tuyến đã duyệt hoặc đã hủy' ];
            return response()->json($response, 430);
        }
        if($registration->student->parent_id != $parent_id){
            $response = [ 'message ' => 'Không có quyền hủy đăng ký này' ];
            return response()->json($response, 430);
        }

        $registration->delete();

        return response()->json($response, 200);
    }

    //Xin phép nghỉ cho học sinh
    public function requestAbsence(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'parent_id' => 'required',
            'studenttrip_id' =>'required'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $parent_id = $req->parent_id;
        $studenttrip_id = $req->studenttrip_id;

        $studenttrip = StudentTrip::find($studenttrip_id);
        if($studenttrip == NULL){
            $response = [ 'message ' => 'Không có thông tin đi xe của học sinh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->student->parent_id != $parent_id){
            $response = [ 'message ' => 'Không có quyền xin phép cho học sinh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->on_at != NULL){
            $response = [ 'message ' => 'Học sinh đã tham gia chuyến' ];
            return response()->json($response, 430);
        }

        $studenttrip->absence_req = 1;
        $studenttrip->save();
        return response()->json($response, 200);
    }
}
