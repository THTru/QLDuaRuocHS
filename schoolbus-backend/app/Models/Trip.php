<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Trip extends Model
{
    use HasFactory;

    protected $table='trips';
    protected $primaryKey='trip_id';

    public function line(){
        return $this->belongsTo(Line::class, 'line_id', 'line_id');
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

    public function studenttrip(){
        return $this->hasMany(StudentTrip::class, 'trip_id', 'trip_id');
    }
}
