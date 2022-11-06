<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Registration extends Model
{
    use HasFactory;

    protected $table='registrations';
    protected $primaryKey='reg_id';

    public function student(){
        return $this->belongsTo(Student::class, 'student_id', 'student_id');
    }

    public function line(){
        return $this->belongsTo(Line::class, 'line_id', 'line_id');
    }

    public function stop(){
        return $this->belongsTo(Stop::class, 'stop_id', 'stop_id');
    }
}
