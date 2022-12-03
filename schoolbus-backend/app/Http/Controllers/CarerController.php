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
use App\Models\Registration;
use App\Models\Trip; //Start, End
use App\Models\StudentTrip; //CheckOn, CheckOff, CheckAbsence
use App\Models\User;

class CarerController extends Controller
{
    //=========================================== TRIP & STUDENTTRIP ==============================================
    //Bắt đầu chuyến xe
    public function startTrip(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'trip_id' => 'required',
            'carer_id' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $trip_id = $req->trip_id;
        $carer_id = $req->carer_id;

        $trip = Trip::find($trip_id);
        if($trip == NULL){
            $response = [ 'message ' => 'Không tìm thấy chuyến' ];
            return response()->json($response, 430);
        }
        if($trip->start_at != NULL){
            $response = [ 'message ' => 'Chuyến đã khởi hành' ];
            return response()->json($response, 430);
        }
        if($trip->carer_id != $carer_id){
            $response = [ 'message ' => 'Không có quyền bắt đầu chuyến' ];
            return response()->json($response, 430);
        }
        if($trip->line->linetype->is_back == 1){
            $allIn = true;
            foreach($trip->studenttrip as $studentInfo){
                if($studentInfo->on_at == NULL && $studentInfo->absence == 0) $allIn = false;
            }
            if(!$allIn){
                $response = [ 'message ' => 'Học sinh chưa lên xe đủ' ];
                return response()->json($response, 430);
            }
        }

        $start_at = Carbon::now()->setTimezone('+7');
        $trip->start_at = $start_at->format('H:i:s');
        $trip->save();

        return response()->json($response, 200);
    }

    //Điểm danh khi học sinh lên xe
    public function checkOnStudentTrip(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'studenttrip_id' => 'required',
            'carer_id' => 'required',
        ];

        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $studenttrip_id = $req->studenttrip_id;
        $carer_id = $req->carer_id;

        $studenttrip = StudentTrip::find($studenttrip_id);
        if($studenttrip == NULL){
            $response = [ 'message ' => 'Không tìm thấy thông tin đi xe của học sinh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->trip->carer_id != $carer_id){
            $response = [ 'message ' => 'Không có quyền điểm danh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->trip->line->linetype->is_back == 0 && $studenttrip->trip->start_at == NULL){
            $response = [ 'message ' => 'Xe chưa khởi hành' ];
            return response()->json($response, 430);
        }

        $on_at = Carbon::now()->setTimezone('+7');
        $studenttrip->on_at = $on_at->format('H:i:s');
        $studenttrip->save();
        return response()->json($response, 200);
    }

    //Điểm danh học sinh khi xuống xe
    public function checkOffStudentTrip(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'studenttrip_id' => 'required',
            'carer_id' => 'required',
        ];

        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $studenttrip_id = $req->studenttrip_id;
        $carer_id = $req->carer_id;

        $studenttrip = StudentTrip::find($studenttrip_id);
        if($studenttrip == NULL){
            $response = [ 'message ' => 'Không tìm thấy thông tin đi xe của học sinh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->trip->carer_id != $carer_id){
            $response = [ 'message ' => 'Không có quyền điểm danh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->on_at == NULL){
            $response = [ 'message ' => 'Học sinh chưa lên xe' ];
            return response()->json($response, 430);
        }
        if($studenttrip->off_at != NULL){
            $response = [ 'message ' => 'Học sinh đã xuống xe' ];
            return response()->json($response, 430);
        }

        $off_at = Carbon::now()->setTimezone('+7');
        $studenttrip->off_at = $off_at->format('H:i:s');
        $studenttrip->save();
        return response()->json($response, 200);
    }

    //Xác nhận vắng
    public function checkAbsenceStudentTrip(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'studenttrip_id' => 'required',
            'carer_id' => 'required',
        ];

        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $studenttrip_id = $req->studenttrip_id;
        $carer_id = $req->carer_id;

        $studenttrip = StudentTrip::find($studenttrip_id);
        if($studenttrip == NULL){
            $response = [ 'message ' => 'Không tìm thấy thông tin đi xe của học sinh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->trip->carer_id != $carer_id){
            $response = [ 'message ' => 'Không có quyền điểm danh' ];
            return response()->json($response, 430);
        }
        if($studenttrip->on_at != NULL){
            $response = [ 'message ' => 'Học sinh đã tham gia chuyến' ];
            return response()->json($response, 430);
        }

        $studenttrip->absence = 1;
        $studenttrip->save();
        return response()->json($response, 200);
    }

    //Kết thúc chuyến xe
    public function endTrip(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'trip_id' => 'required',
            'carer_id' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 430);
        }

        $trip_id = $req->trip_id;
        $carer_id = $req->carer_id;

        $trip = Trip::find($trip_id);
        if($trip == NULL){
            $response = [ 'message ' => 'Không tìm thấy chuyến' ];
            return response()->json($response, 430);
        }
        if($trip->end_at != NULL){
            $response = [ 'message ' => 'Chuyến đã kết thúc' ];
            return response()->json($response, 430);
        }
        if($trip->carer_id != $carer_id){
            $response = [ 'message ' => 'Không có quyền kết thúc đầu chuyến' ];
            return response()->json($response, 430);
        }

        $allIn = true;
        foreach($trip->studenttrip as $studentInfo){
            if($studentInfo->on_at == NULL && $studentInfo->absence == 0) $allIn = false;
        }
        if(!$allIn){
            $response = [ 'message ' => 'Học sinh chưa lên xe đủ' ];
            return response()->json($response, 430);
        }

        $allOut = true;
        foreach($trip->studenttrip as $studentInfo){
            if($studentInfo->on_at != NULL && $studentInfo->off_at == NULL) $allOut = false;
        }
        if(!$allOut){
            $response = [ 'message ' => 'Học sinh chưa xuống xe hết' ];
            return response()->json($response, 430);
        }

        $end_at = Carbon::now()->setTimezone('+7');
        $trip->end_at = $end_at->format('H:i:s');
        $trip->save();
        return response()->json($response, 200);
    }
}
