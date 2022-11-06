<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stop extends Model
{
    use HasFactory;

    protected $table='stops';
    protected $primaryKey='stop_id';

    public function stopschedule(){
        return $this->hasMany(StopSchedule::class, 'stop_id', 'stop_id');
    }

    public function registration(){
        return $this->hasMany(Registration::class, 'stop_id', 'stop_id');
    }

    public function studenttrip(){
        return $this->hasMany(StudentTrip::class, 'stop_id', 'stop_id');
    }
}
