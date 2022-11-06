<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Line extends Model
{
    use HasFactory;

    protected $table='lines';
    protected $primaryKey='line_id';

    public function linetype(){
        return $this->belongsTo(LineType::class, 'linetype_id', 'linetype_id');
    }

    public function driver(){
        return $this->belongsTo(Driver::class, 'driver_id', 'driver_id');
    }

    public function vehicle(){
        return $this->belongsTo(Vehicle::class, 'vehicle_id', 'vehicle_id');
    }

    public function carer(){
        return $this->belongsTo(User::class, 'carer_id', 'id');
    }

    public function schedule(){
        return $this->belongsTo(Schedule::class, 'schedule_id', 'schedule_id');
    }

    public function registration(){
        return $this->hasMany(Registration::class, 'line_id', 'line_id');
    }

    public function trip(){
        return $this->hasMany(Trip::class, 'line_id', 'line_id');
    }
}
