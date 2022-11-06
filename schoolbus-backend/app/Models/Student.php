<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    use HasFactory;

    protected $table = 'students';
    protected $primaryKey='student_id';
    protected $keyType='string';


    public function parent(){
        return $this->belongsTo(User::class, 'parent_id', 'id');
    }

    public function class(){
        return $this->belongsTo(Hclass::class, 'class_id', 'class_id');
    }

    public function registration(){
        return $this->hasMany(Registration::class, 'student_id', 'student_id');
    }

    public function studenttrip(){
        return $this->hasMany(StudentTrip::class, 'student_id', 'student_id');
    }
}
