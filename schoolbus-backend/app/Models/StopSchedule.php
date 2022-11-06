<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StopSchedule extends Model
{
    use HasFactory;

    protected $table='stopschedules';
    protected $primaryKey='stopschedule_id';

    public function stop(){
        return $this->belongsTo(Stop::class, 'stop_id', 'stop_id');
    }

    public function schedule(){
        return $this->belongsTo(Schedule::class, 'schedule_id', 'schedule_id');
    }
}
