<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StudentTrip extends Model
{
    use HasFactory;

    protected $table='studenttrips';
    protected $primaryKey='studenttrip_id';

    public function student(){
        return $this->belongsTo(Student::class, 'student_id', 'student_id');
    }

    public function trip(){
        return $this->belongsTo(Trip::class, 'trip_id', 'trip_id');
    }

    public function stop(){
        return $this->belongsTo(Stop::class, 'stop_id', 'stop_id');
    }
}
