<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vehicle extends Model
{
    use HasFactory;

    protected $table='vehicles';
    protected $primaryKey='vehicle_id';

    public function line(){
        return $this->hasMany(Line::class, 'vehicle_id', 'vehicle_id');
    }

    public function trip(){
        return $this->hasMany(Trip::class, 'vehicle_id', 'vehicle_id');
    }
}
