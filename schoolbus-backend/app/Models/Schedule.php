<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Schedule extends Model
{
    use HasFactory;

    protected $table='schedules';
    protected $primaryKey='schedule_id';

    public function stopschedule(){
        return $this->hasMany(StopSchedule::class, 'schedule_id', 'schedule_id');
    }

    public function line(){
        return $this->hasMany(Line::class, 'schedule_id', 'schedule_id');
    }
}
