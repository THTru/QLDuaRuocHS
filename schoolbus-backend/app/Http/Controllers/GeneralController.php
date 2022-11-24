<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
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
use App\Models\Trip;
use App\Models\StudentTrip;
use App\Models\User;

class GeneralController extends Controller
{
    const limitofPage = 1;
    //=========================================== USER ==============================================
    public function users(Request $req){
        // $page=$req->page; //Số trang
        // $type=$req->type; //Loại
        
        // $skip=0;
        // if($req->page != NULL && $req->page>0){
        //     $skip=$req->page-1;
        // }
        // $users = User::with('student');
        // if($req->type != NULL){
        //     $users = $users->where('type', '=', $req->type);
        // }

        // return $users->skip($skip)->take(self::limitofPage)->get();
        return User::all();
    }

    public function usersbyType(Request $req){
        $keyword1 = $req->type;
        $keyword2 = $req->name;
        $users = User::where('name', 'LIKE', '%'.$keyword2.'%');
        if ($keyword1 != 0)
            return $users->where('type', '=', $keyword1)->get();
        else return $users->get();
    }
    
    public function test(Request $req){ //Test thôi
        return Student::with('class')->get();
    }

    //=========================================== CLASS ==============================================
    //Lấy toàn bộ lớp
    public function classes(Request  $req){
        return Hclass::get();
    }

    //Lấy lớp theo ID
    public function class(Request $req){
        $keyword=$req->class_id;
        return Hclass::find($keyword);
    }

    //=========================================== STUDENT ==============================================
    //Lấy toàn bộ học sinh + lớp
    public function students(Request $req){
        return Student::with('class')->get();
    }

    //Lấy học sinh + lớp theo tên tìm kiếm
    public function studentsbyName(Request $req){
        $keyword = $req->student_name;
        return Student::where('student_name', 'LIKE', '%'.$keyword.'%')->with('class')->get();
    }

    //Lấy các học sinh + lớp theo phụ huynh
    public function studentsbyParent(Request $req){
        $keyword = $req->parent_id;
        return Student::where('parent_id', '=', $keyword)->with('class')->get();
    }

    //Lấy các học sinh theo lớp
    public function studentsbyClass(Request $req){
        $keyword = $req->class_id;
        return Student::where('class_id', '=', $keyword)->get();
    }

    //Lấy học sinh + lớp theo ID
    public function student(Request $req){
        $keyword = $req->student_id;
        return Student::with('class')->find($keyword);
    }

    //=========================================== DRIVER ==============================================
    //Lấy tất cả tài xế
    public function drivers(Request $req){
        return Driver::get();
    }

    //Lấy các tài xế theo tên
    public function driversbyName(Request $req){
        $keyword = $req->driver_name;
        return Driver::where('driver_name', 'LIKE', '%'.$keyword.'%')->get();
    }

    //Lấy tài xế theo ID
    public function driver(Request $req){
        $keyword = $req->driver_id;
        return Driver::find($keyword);
    }

    //=========================================== VEHICLE ==============================================
    //Lấy tất cả xe
    public function vehicles(Request $req){
        return Vehicle::get();
    }

    //Lấy các xe theo biển số
    public function vehiclesbyNumber(Request $req){
        $keyword = $req->vehicle_no;
        return Vehicle::where('vehicle_no', 'LIKE', '%'.$keyword.'%')->get();
    }

    //Lấy xe theo ID
    public function vehicle(Request $req){
        $keyword = $req->vehicle_id;
        return Vehicle::find($keyword);
    }

    //=========================================== STOP ==============================================
    //Lấy tất cả điểm dừng
    public function stops(Request $req){
        return Stop::get();
    }

    //Lấy các điểm dừng theo tên
    public function stopsbyName(Request $req){
        $keyword = $req->location;
        return Stop::where('location', 'LIKE', '%'.$keyword.'%')->get();
    }

    //Lấy các điểm dừng theo quận
    public function stopsbyDistrict(Request $req){
        $keyword = $req->district;
        return Stop::where('district', '=', $keyword)->get();
    }

    //Lấy các điểm dừng theo phường
    public function stopsbyWard(Request $req){
        $keyword = $req->ward;
        return Stop::where('ward', '=', $keyword)->get();
    }

    //Lấy điểm dừng theo ID
    public function stop(Request $req){
        $keyword = $req->stop_id;
        return Stop::find($keyword);
    }

    //=========================================== SCHEDULE ==============================================
    //Lấy tất cả các lộ trình
    public function schedules(Request $req){
        return Schedule::with('stopschedule.stop')->get();
    }

    //Lấy các lộ trình theo tên
    public function schedulesbyName(Request $req){
        $keyword = $req->schedule_name;
        return Schedule::where('schedule_name', 'LIKE', '%'.$keyword.'%')->with('stopschedule.stop')->get();
    }

    //Lấy lộ trình theo ID
    public function schedule(Request $req){
        $keyword = $req->schedule_id;
        return Schedule::with('stopschedule.stop')->find($keyword);
    }

    //=========================================== LINETYPE ==============================================
    //Lấy tất cả loại tuyến
    public function linetypes(Request $req){
        return Linetype::get();
    }

    //Lọc, tìm kiếm các loại tuyến theo kiểu đi hay về, buổi
    public function linetypesFilter(Request $req){
        $keyword1 = $req->is_back; // 0 là đi học, 1 là đi về, -1 là cả hai
        $keyword2 = $req->shift; // 0 là sáng, 1 là chiều, -1 là cả hai

        $linetypes = Linetype::where('linetype_name', 'LIKE', '%');
        if($keyword1 != -1)
            $linetypes = $linetypes->where('is_back','=', $keyword1);
        if($keyword2 != -1){
            if($keyword2==0)
                $linetypes =  $linetypes->where('time_start','<','12:00:00');
            else
                $linetypes = $linetypes->where('time_start','>=','12:00:00');
        }
        return $linetypes->get();
    }

    //Lấy loại tuyến theo ID
    public function linetype(Request $req){
        $keyword = $req->linetype_id;
        return LineType::find($keyword);
    }

    //=========================================== LINE ==============================================
    //Lấy tất cả tuyến
    public function lines(Request $req){
        return Line::with('linetype')->get();
    }

    //Lọc, tìm kiếm các tuyến theo ngày, trạng thái, loại tuyến, bảo mẫu, tài xế, xe
    public function linesFilter(Request $req){
        $keyword1 = $req->date; //ngày trong thời gian tuyến chạy, -1 là tất cả
        $keyword2 = $req->line_status; // 0: chưa công bố, 1: công bố, 2: chốt đăng ký, 3: hủy
        $keyword3 = $req->linetype_id; // -1 là tất cả
        $keyword4 = $req->carer_id; // -1 là tất cả
        $keyword5 = $req->driver_id; // -1 là tất cả
        $keyword6 = $req->vehicle_id; // -1 là tất cả

        $lines = Line::with('linetype');
        if($keyword1 != -1){
            $lines = $lines->whereDate('first_date','<=', $keyword1)->whereDate('last_date','>=', $keyword1);
        }
        if($keyword2 != -1){
            $lines = $lines->where('line_status','=', $keyword2);
        }
        if($keyword3 != -1){
            $lines = $lines->where('linetype_id','=', $keyword3);
        }
        if($keyword4 != -1){
            $lines = $lines->where('carer_id','=', $keyword4);
        }
        if($keyword5 != -1){
            $lines = $lines->where('driver_id','=', $keyword5);
        }
        if($keyword6 != -1){
            $lines = $lines->where('vehicle_id','=', $keyword6);
        }
        return $lines->get();
    }

    //Lấy tuyến theo ID
    public function line(Request $req){
        $keyword = $req->line_id;
        return Line::with('linetype', 'carer', 'driver', 'vehicle', 'schedule')->find($keyword);
    }

    //=========================================== TRIP ==============================================
    //Lấy tất cả chuyến
    public function trips(Request $req){
        return Trip::with('carer')->get();
    }

    //Lọc, tìm kiếm các chuyến theo ngày, tuyến, bảo mẫu, tài xế, xe
    public function tripsFilter(Request $req){
        $keyword1 = $req->date; //ngày trong thời gian tuyến chạy, -1 là tất cả
        $keyword2 = $req->line_id; // -1 là tất cả
        $keyword3 = $req->carer_id; // -1 là tất cả
        $keyword4 = $req->driver_id; // -1 là tất cả
        $keyword5 = $req->vehicle_id; // -1 là tất cả
        $keyword6 = $req->finish; // 0 là chưa chạy, 1 là chạy rồi, -1 là tất cả
        
        $trips = Trip::with('carer');
        if($keyword1 != -1){
            $trips = $trips->whereDate('date','=', $keyword1);
        }
        if($keyword2 != -1){
            $trips = $trips->where('line_id','=', $keyword2);
        }
        if($keyword3 != -1){
            $trips = $trips->where('carer_id','=', $keyword3);
        }
        if($keyword4 != -1){
            $trips = $trips->where('driver_id','=', $keyword4);
        }
        if($keyword5 != -1){
            $trips = $trips->where('vehicle_id','=', $keyword5);
        }
        if($keyword6 != -1){
            if($keyword6 == 0) $trips = $trips->whereNULL('end_at');
            else if($keyword6 == 1) $trips = $trips->whereNotNull('end_at');
        }

        return $trips->get();
    }

    //Lấy chuyến theo ID
    public function trip(Request $req){
        $keyword = $req->trip_id;
        return Trip::with('carer', 'driver', 'vehicle')->find($keyword);
    }
}