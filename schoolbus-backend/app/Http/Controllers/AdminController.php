<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\Hclass; //New, Edit, Delete
use App\Models\Student; //New, Edit, Delete, BondwithParent
use App\Models\Vehicle; //New, Edit, Delete
use App\Models\Driver; //New, Edit, Delete
use App\Models\Stop; //New, Edit, Delete
use App\Models\Schedule; //New, Edit name+des, Delete
use App\Models\StopSchedule;
use App\Models\LineType; //New, Edit, Delete
use App\Models\Line; //New, Edit (-schedule, linetype), ChangeStatus,Delete
use App\Models\Registration;
use App\Models\Trip;
use App\Models\StudentTrip;
use App\Models\DayOff; //New, Edit, Delete
use App\Models\User; //New, Edit, Delete, ChangePW

class AdminController extends Controller
{
    //=========================================== DAYOFF ==============================================
    //Tạo ngày nghỉ mới
    public function newDayOff(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'date' =>'required|date_format:Y/m/d',
            'name' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $date = $req->date;
        $name = $req->name;

        $newDayOff = new DayOff;
        $newDayOff->date = $date;
        $newDayOff->name = $name;
        $newDayOff->save();

        return response()->json($response, 200);
    }

    //Sửa ngày nghỉ
    public function editDayOff(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'id' => 'required',
            'date' =>'required|date_format:Y/m/d',
            'name' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $id = $req->id;
        $date = $req->date;
        $name = $req->name;

        $dayOff = DayOff::find($id);
        if($dayOff == NULL){
            $response = ['message' => 'Không tìm thấy user'];
            return response()->json($response, 400);
        }
        $dayOff->date = $date;
        $dayOff->name = $name;
        $dayOff->save();

        return response()->json($response, 200);
    }

    //Xóa ngày nghỉ
    public function deleteDayOff(Request $req){
        $response = [ 'message' => 'OK'];

        $id = $req->id;

        $dayOff = DayOff::find($id);
        if($dayOff == NULL){
            $response = ['message' => 'Không tìm thấy người dùng'];
            return response()->json($response, 400);
        }

        $dayOff->delete();
        return response()->json($response, 200);
    }
    
    //=========================================== USER ==============================================
    //Tạo người dùng mới
    public function newUser(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'name' =>'required',
            'type' => 'required|integer',
            'email' => 'required',
            'password' => 'required|min:6',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $name = $req->name;
        $type = $req->type;
        $email = $req->email;
        $password = $req->password;
        $phone = $req->phone;
        if(User::where('email', $email)->exists()){
            $response = ['message' => 'Email đã được sử dụng'];
            return response()->json($response, 400);
        }
        $newUser = new User;
        $newUser->name = $name;
        $newUser->type = $type;
        $newUser->email = $email;
        $newUser->password = Hash::make($password);
        $newUser->status = 1;
        $newUser->phone = $phone;
        $newUser->save();

        return response()->json($response, 200);
    }

    //Sửa thông tin người dùng
    public function editUser(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'name' =>'required',
            'id' => 'required|integer',
            'status' => 'required'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $name = $req->name;
        $id = $req->id;
        $phone = $req->phone;
        $status = $req->status;

        $user = User::find($id);
        if($user == NULL){
            $response = ['message' => 'Không tìm thấy user'];
            return response()->json($response, 400);
        }
        $user->name = $name;
        $user->phone = $phone;
        $user->status = $status;
        $user->save();

        return response()->json($response, 200);
    }

    //Đổi mật khẩu
    public function changePassword(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'password' =>'required|min:6',
            'id' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $password = $req->password;
        $id = $req->id;

        $user = User::find($id);
        if($user == NULL){
            $response = ['message' => 'Không tìm thấy user'];
            return response()->json($response, 400);
        }
        $user->password = Hash::make($password);
        $user->save();

        return response()->json($response, 200);
    }

    //Xóa người dùng
    public function deleteUser(Request $req){
        $response = [ 'message' => 'OK'];

        $id = $req->id;

        $user = User::find($id);
        if($user == NULL){
            $response = ['message' => 'Không tìm thấy người dùng'];
            return response()->json($response, 400);
        }

        $user->delete();
        return response()->json($response, 200);
    }

    //=========================================== CLASS ==============================================
    //Tạo lớp mới
    public function newClass(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'class_id' =>'required',
            'class_name' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $class_id = $req->class_id;
        $class_name = $req->class_name;

        if(Hclass::find($class_id) != NULL){
            $response = ['message' => 'Mã lớp đã sử dụng'];
            return response()->json($response, 400);
        }
        $newClass = new Hclass;
        $newClass->class_id = $class_id;
        $newClass->class_name = $class_name;
        $newClass->save();

        return response()->json($response, 200);
    }

    //Sửa thông tin lớp
    public function editClass(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'class_id' =>'required',
            'class_name' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $class_id = $req->class_id;
        $class_name = $req->class_name;

        $class = Hclass::find($class_id);
        if($class == NULL){
            $response = ['message' => 'Không tìm thấy lớp'];
            return response()->json($response, 400);
        }
        $class->class_name = $class_name;
        $class->save();

        return response()->json($response, 200);
    }

    //Xóa lớp
    public function deleteClass(Request $req){
        $response = [ 'message' => 'OK'];

        $class_id = $req->class_id;

        $class = Hclass::find($class_id);
        if($class == NULL){
            $response = ['message' => 'Không tìm thấy lớp'];
            return response()->json($response, 400);
        }

        $class->delete();
        return response()->json($response, 200);
    }

    //=========================================== STUDENT ==============================================
    //Tạo học sinh mới
    public function newStudent(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'student_id' => 'required',
            'student_name' => 'required',
            'class_id' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $student_id = $req->student_id;
        $student_name = $req->student_name;
        $class_id = $req->class_id;

        if(Student::where('student_id', $student_id)->exists()){
            $response = ['message' => 'Mã học sinh đã sử dụng'];
            return response()->json($response, 400);
        }
        if(!Hclass::where('class_id', $class_id)->exists()){
            $response = ['message' => 'Mã lớp không tồn tại'];
            return response()->json($response, 400);
        }

        $newStudent = new Student;
        $newStudent->student_id = $student_id;
        $newStudent->student_name = $student_name;
        $newStudent->class_id = $class_id;
        $newStudent->save();

        return response()->json($response, 200);
    }

    //Sửa thông tin học sinh
    public function editStudent(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'student_id' =>'required',
            'student_name' =>'required',
            'class_id' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $student_id = $req->student_id;
        $student_name = $req->student_name;
        $class_id = $req->class_id;

        $student = Student::find($student_id);
        if($student == NULL){
            $response = ['message' => 'Không tìm thấy học sinh'];
            return response()->json($response, 400);
        }
        if(!Hclass::where('class_id', $class_id)->exists()){
            $response = ['message' => 'Mã lớp không tồn tại'];
            return response()->json($response, 400);
        }

        $student->student_name = $student_name;
        $student->class_id = $class_id;
        $student->save();

        return response()->json($response, 200);
    }

    //Tạo liên kết học sinh với phụ huynh
    public function bondParentStudent(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'student_id' => 'required',
            'parent_id' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $student_id = $req->student_id;
        $parent_id = $req->parent_id;

        $student = Student::find($student_id);
        if($student == NULL){
            $response = ['message' => 'Không tìm thấy học sinh'];
            return response()->json($response, 400);
        }

        $parent = User::find($parent_id);
        if($parent == NULL || $parent->type != 3){
            $response = ['message' => 'Không tìm thấy phụ huynh'];
            return response()->json($response, 400);
        }

        $student->parent_id = $parent_id;
        $student->save();
        return response()->json($response, 200);
    }

    //Xóa học sinh
    public function deleteStudent(Request $req){
        $response = [ 'message' => 'OK'];

        $student_id = $req->student_id;

        $student = Student::find($student_id);
        if($student == NULL){
            $response = ['message' => 'Không tìm thấy học sinh'];
            return response()->json($response, 400);
        }

        $student->delete();
        return response()->json($response, 200);
    }

    //=========================================== VEHICLE ==============================================
    //Tạo xe mới
    public function newVehicle(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'vehicle_no' => 'required',
            'capacity' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $vehicle_no = $req->vehicle_no;
        $capacity = $req->capacity;

        if(Vehicle::where('vehicle_no', $vehicle_no)->exists()){
            $response = ['message' => 'Số xe đã sử dụng'];
            return response()->json($response, 400);
        }
        $newVehicle = new Vehicle;
        $newVehicle->vehicle_no = $vehicle_no;
        $newVehicle->vehicle_status = 1;
        $newVehicle->capacity = $capacity;
        $newVehicle->save();

        return response()->json($response, 200);
    }

    //Sửa thông tin xe
    public function editVehicle(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'vehicle_id' =>'required|integer',
            'vehicle_no' => 'required',
            'vehicle_status' => 'required|integer',
            'capacity' => 'required|integer'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $vehicle_id = $req->vehicle_id;
        $vehicle_no = $req->vehicle_no;
        $vehicle_status = $req->vehicle_status;
        $capacity = $req->capacity;

        $vehicle = Vehicle::find($vehicle_id);
        if($vehicle == NULL){
            $response = ['message' => 'Không tìm thấy xe'];
            return response()->json($response, 400);
        }
        $vehicle->vehicle_no = $vehicle_no;
        $vehicle->vehicle_status = $vehicle_status;
        $vehicle->capacity = $capacity;
        $vehicle->save();

        return response()->json($response, 200);
    }

    //Xóa xe
    public function deleteVehicle(Request $req){
        $response = [ 'message' => 'OK'];

        $vehicle_id = $req->vehicle_id;

        $vehicle = Vehicle::find($vehicle_id);
        if($vehicle == NULL){
            $response = ['message' => 'Không tìm thấy xe'];
            return response()->json($response, 400);
        }

        $vehicle->delete();
        return response()->json($response, 200);
    }

    //=========================================== DRIVER ==============================================
    //Tạo tài xế mới
    public function newDriver(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'driver_name' => 'required',
            'driver_phone' => 'required',
            'driver_address' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $driver_name = $req->driver_name;
        $driver_phone = $req->driver_phone;
        $driver_address = $req->driver_address;

        $newDriver = new Driver;
        $newDriver->driver_name = $driver_name;
        $newDriver->driver_phone = $driver_phone;
        $newDriver->driver_address = $driver_address;
        $newDriver->save();

        return response()->json($response, 200);
    }

    //Sửa thông tin tài xế
    public function editDriver(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'driver_id' =>'required|integer',
            'driver_name' => 'required',
            'driver_phone' => 'required',
            'driver_address' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $driver_id = $req->driver_id;
        $driver_name = $req->driver_name;
        $driver_phone = $req->driver_phone;
        $driver_address = $req->driver_address;

        $driver = Driver::find($driver_id);
        if($driver == NULL){
            $response = ['message' => 'Không tìm thấy tài xế'];
            return response()->json($response, 400);
        }
        $driver->driver_name = $driver_name;
        $driver->driver_phone = $driver_phone;
        $driver->driver_address = $driver_address;
        $driver->save();

        return response()->json($response, 200);
    }

    //Xóa tài xế
    public function deleteDriver(Request $req){
        $response = [ 'message' => 'OK'];

        $driver_id = $req->driver_id;

        $driver = Driver::find($driver_id);
        if($driver == NULL){
            $response = ['message' => 'Không tìm thấy tài xế'];
            return response()->json($response, 400);
        }

        $driver->delete();
        return response()->json($response, 200);
    }

    //=========================================== STOP ==============================================
    //Tạo điểm dừng mới
    public function newStop(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'location' => 'required',
            'ward' => 'required',
            'district' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $location = $req->location;
        $ward = $req->ward;
        $district = $req->district;

        $newStop = new Stop;
        $newStop->location = $location;
        $newStop->ward = $ward;
        $newStop->district = $district;
        $newStop->save();

        return response()->json($response, 200);
    }

    //Sửa điểm dừng
    public function editStop(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'stop_id' =>'required|integer',
            'location' => 'required',
            'ward' => 'required',
            'district' => 'required',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $stop_id = $req->stop_id;
        $location = $req->location;
        $ward = $req->ward;
        $district = $req->district;

        $stop = Stop::find($stop_id);
        if($stop == NULL){
            $response = ['message' => 'Không tìm thấy điểm dừng'];
            return response()->json($response, 400);
        }
        $stop->location = $location;
        $stop->ward = $ward;
        $stop->district = $district;
        $stop->save();

        return response()->json($response, 200);
    }

    //Xóa điểm dừng
    public function deleteStop(Request $req){
        $response = [ 'message' => 'OK'];

        $stop_id = $req->stop_id;

        $stop = Stop::find($stop_id);
        if($stop == NULL){
            $response = ['message' => 'Không tìm thấy điểm dừng'];
            return response()->json($response, 400);
        }

        $stop->delete();
        return response()->json($response, 200);
    }

    //=========================================== STOP ==============================================
    //Tạo loại tuyến
    public function newLineType(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'linetype_name' =>'required',
            'is_back' => 'required|integer',
            'time_start' => 'required|date_format:H:i',
            'time_end' => 'required|date_format:H:i|after:time_start',
            'mon' => 'required|integer',
            'tue' => 'required|integer',
            'wed' => 'required|integer',
            'thu' => 'required|integer',
            'fri' => 'required|integer',
            'sat' => 'required|integer',
            'sun' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $linetype_name = $req->linetype_name;
        $is_back = $req->is_back; if($is_back != 1) $is_back =0;
        $time_start = $req->time_start;
        $time_end = $req->time_end;
        $mon = $req->mon; if($mon != 1) $mon =0;
        $tue = $req->tue; if($tue != 1) $tue =0;
        $wed = $req->wed; if($wed != 1) $wed =0;
        $thu = $req->thu; if($thu != 1) $thu =0;
        $fri = $req->fri; if($fri != 1) $fri =0;
        $sat = $req->sat; if($sat != 1) $sat =0;
        $sun = $req->sun; if($sun != 1) $sun =0;

        $newLineType = new LineType;
        $newLineType->linetype_name = $linetype_name;
        $newLineType->is_back = $is_back;
        $newLineType->time_start = $time_start;
        $newLineType->time_end = $time_end;
        $newLineType->mon = $mon;
        $newLineType->tue = $tue;
        $newLineType->wed = $wed;
        $newLineType->thu = $thu;
        $newLineType->fri = $fri;
        $newLineType->sat = $sat;
        $newLineType->sun = $sun;
        $newLineType->save();

        return response()->json($response, 200);
    }

    //Sửa thông tin loại tuyến
    public function editLineType(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'linetype_id' => 'required',
            'linetype_name' =>'required',
            'is_back' => 'required|integer',
            'time_start' => 'required|date_format:H:i',
            'time_end' => 'required|date_format:H:i|after:time_start',
            'mon' => 'required|integer',
            'tue' => 'required|integer',
            'wed' => 'required|integer',
            'thu' => 'required|integer',
            'fri' => 'required|integer',
            'sat' => 'required|integer',
            'sun' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $linetype_id = $req->linetype_id;
        $linetype_name = $req->linetype_name;
        $is_back = $req->is_back; if($is_back != 1) $is_back =0;
        $time_start = $req->time_start;
        $time_end = $req->time_end;
        $mon = $req->mon; if($mon != 1) $mon =0;
        $tue = $req->tue; if($tue != 1) $tue =0;
        $wed = $req->wed; if($wed != 1) $wed =0;
        $thu = $req->thu; if($thu != 1) $thu =0;
        $fri = $req->fri; if($fri != 1) $fri =0;
        $sat = $req->sat; if($sat != 1) $sat =0;
        $sun = $req->sun; if($sun != 1) $sun =0;

        $lineType = LineType::find($linetype_id);
        if($lineType == NULL){
            $response = ['message' => 'Không tìm thấy loại tuyến'];
            return response()->json($response, 400);
        }

        $lineType->linetype_name = $linetype_name;
        $lineType->is_back = $is_back;
        $lineType->time_start = $time_start;
        $lineType->time_end = $time_end;
        $lineType->mon = $mon;
        $lineType->tue = $tue;
        $lineType->wed = $wed;
        $lineType->thu = $thu;
        $lineType->fri = $fri;
        $lineType->sat = $sat;
        $lineType->sun = $sun;
        $lineType->save();

        return response()->json($response, 200);
    }

    //Xóa loại tuyến
    public function deleteLineType(Request $req){
        $response = [ 'message' => 'OK'];

        $linetype_id = $req->linetype_id;

        $lineType = LineType::find($linetype_id);
        if($lineType == NULL){
            $response = ['message' => 'Không tìm thấy loại tuyến'];
            return response()->json($response, 400);
        }

        $lineType->delete();
        return response()->json($response, 200);
    }

    //=========================================== SCHEDULE ==============================================
    //Tạo lịch trình
    public function newSchedule(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'schedule_name' => 'required',
            'schedule_des' => 'required',
            'stops' => 'required|array|min:1',
            'time_take' => 'required|array|min:1',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $schedule_name = $req->schedule_name;
        $schedule_des = $req->schedule_des;
        $stops = $req->stops;
        $time_take = $req->time_take;

        for($i=0; $i<count($stops); $i++){
            if(Stop::find($stops[$i]) == NULL){
                $response = ['message' => 'Không tìm thấy điểm dừng'];
                return response()->json($response, 400);
            }
        }

        $newSchedule = new Schedule;
        $newSchedule->schedule_name = $schedule_name;
        $newSchedule->schedule_des = $schedule_des;
        $newSchedule->save();

        for($i=0; $i<count($stops); $i++){
            $newStopSchedule = new StopSchedule;
            $newStopSchedule->schedule_id = $newSchedule->schedule_id;
            $newStopSchedule->stop_id = $stops[$i];
            $newStopSchedule->time_take = $time_take[$i];
            $newStopSchedule->save();
        }

        return response()->json($response, 200);
    }

    //Sửa tên và mô tả lịch trình
    public function editSchedule(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'schedule_name' => 'required',
            'schedule_des' => 'required',
            'schedule_id' => 'required',
        ];

        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $schedule_id = $req->schedule_id;
        $schedule_name = $req->schedule_name;
        $schedule_des = $req->schedule_des;

        $schedule = Schedule::find($schedule_id);
        if($schedule == NULL){
            $response = ['message' => 'Không tìm thấy lịch trình'];
            return response()->json($response, 400);
        }
        $schedule->schedule_name = $schedule_name;
        $schedule->schedule_des = $schedule_des;
        $schedule->save();

        return response()->json($response, 200);
    }
    
    //Xóa lịch trình
    public function deleteSchedule(Request $req){
        $response = [ 'message' => 'OK'];

        $schedule_id = $req->schedule_id;

        $schedule = Schedule::find($schedule_id);
        if($schedule == NULL){
            $response = ['message' => 'Không tìm thấy lịch trình'];
            return response()->json($response, 400);
        }

        $schedule->delete();
        return response()->json($response, 200);
    }

    //=========================================== LINE ==============================================
    //Tạo tuyến
    public function newLine(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'line_name' => 'required',
            'first_date' => 'required|date_format:Y/m/d',
            'last_date' => 'required|date_format:Y/m/d|after:first_date',
            'slot' => 'required|integer',
            'reg_deadline' => 'required|date_format:Y/m/d',
            'linetype_id' => 'required',
            'schedule_id' => 'required'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $line_name = $req->line_name;
        $first_date = $req->first_date;
        $last_date = $req->last_date;
        $slot = $req->slot;
        $reg_deadline = $req->reg_deadline;
        $linetype_id = $req->linetype_id;
        $schedule_id = $req->schedule_id;
        $vehicle_id = $req->vehicle_id;
        $driver_id = $req->driver_id;
        $carer_id = $req->carer_id;

        if(!LineType::where('linetype_id', $linetype_id)->exists()){
            $response = ['message' => 'Mã loại tuyến không tồn tại'];
            return response()->json($response, 400);
        }
        if(!Schedule::where('schedule_id', $schedule_id)->exists()){
            $response = ['message' => 'Mã lịch trình không tồn tại'];
            return response()->json($response, 400);
        }
        if($vehicle_id != NULL && !Vehicle::where('vehicle_id', $vehicle_id)->exists()){
            $response = ['message' => 'Mã xe không tồn tại'];
            return response()->json($response, 400);
        }
        if($driver_id != NULL && !Driver::where('driver_id', $driver_id)->exists()){
            $response = ['message' => 'Mã tài xế không tồn tại'];
            return response()->json($response, 400);
        }
        if($carer_id != NULL && !User::where('id', $carer_id)->exists()){
            $response = ['message' => 'Mã bảo mẫu không tồn tại'];
            return response()->json($response, 400);
        }

        $newLine = new Line;
        $newLine->line_name = $line_name;
        $newLine->first_date = $first_date;
        $newLine->last_date = $last_date;
        $newLine->slot = $slot;
        $newLine->reg_deadline = $reg_deadline;
        $newLine->linetype_id = $linetype_id;
        $newLine->schedule_id = $schedule_id;
        $newLine->vehicle_id = $vehicle_id;
        $newLine->driver_id = $driver_id;
        $newLine->carer_id = $carer_id;
        $newLine->line_status = 0;
        $newLine->save();

        return response()->json($response, 200);
    }

    //Sửa thông tin tuyến
    public function editLine(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'line_id' => 'required',
            'line_name' => 'required',
            'first_date' => 'required|date_format:Y/m/d',
            'last_date' => 'required|date_format:Y/m/d|after:first_date',
            'slot' => 'required|integer',
            'reg_deadline' => 'required|date_format:Y/m/d',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $line_id = $req->line_id;
        $line_name = $req->line_name;
        $first_date = $req->first_date;
        $last_date = $req->last_date;
        $slot = $req->slot;
        $reg_deadline = $req->reg_deadline;
        $vehicle_id = $req->vehicle_id;
        $driver_id = $req->driver_id;
        $carer_id = $req->carer_id;

        
        if($vehicle_id != NULL && !Vehicle::where('vehicle_id', $vehicle_id)->exists()){
            $response = ['message' => 'Mã xe không tồn tại'];
            return response()->json($response, 400);
        }
        if($driver_id != NULL && !Driver::where('driver_id', $driver_id)->exists()){
            $response = ['message' => 'Mã tài xế không tồn tại'];
            return response()->json($response, 400);
        }
        if($carer_id != NULL && !User::where('id', $carer_id)->exists()){
            $response = ['message' => 'Mã bảo mẫu không tồn tại'];
            return response()->json($response, 400);
        }

        $line = Line::find($line_id);
        if($line == NULL){
            $response = ['message' => 'Không tìm thấy tuyến'];
            return response()->json($response, 400);
        }

        $line->line_name = $line_name;
        $line->first_date = $first_date;
        $line->last_date = $last_date;
        $line->slot = $slot;
        $line->reg_deadline = $reg_deadline;
        $line->vehicle_id = $vehicle_id;
        $line->driver_id = $driver_id;
        $line->carer_id = $carer_id;
        $line->save();

        return response()->json($response, 200);
    }

    //Chuyển trạng thái tuyến
    public function changeLineStatus(Request $req){
        $response = [ 'message' => 'OK'];
        $rules = [
            'line_id' => 'required',
            'line_status' => 'required|integer',
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            $response = [ 'message ' => 'Xin nhập đủ thông tin đúng yêu cầu' ];
            return response()->json($response, 400);
        }

        $line_id = $req->line_id;
        $line_status = $req->line_status; //0: chưa công bố, 1: công bố, 2: chốt đăng ký, 3: hủy

        $line = Line::find($line_id);
        if($line == NULL){
            $response = ['message' => 'Không tìm thấy tuyến'];
            return response()->json($response, 400);
        }

        $line->line_status = $line_status;
        $line->save();
        return response()->json($response, 200);
    }

    //Xóa tuyến
    public function deleteLine(Request $req){
        $response = [ 'message' => 'OK'];

        $line_id = $req->line_id;

        $line = Line::find($line_id);
        if($line == NULL){
            $response = ['message' => 'Không tìm thấy tuyến'];
            return response()->json($response, 400);
        }

        $line->delete();
        return response()->json($response, 200);
    }

    //=========================================== TRIP ==============================================
    //Chốt đăng ký
}
