<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Driver extends Model
{
    use HasFactory;

    protected $table='drivers';
    protected $primaryKey='driver_id';

    public function line(){
        return $this->hasMany(Line::class, 'driver_id', 'driver_id');
    }

    public function trip(){
        return $this->hasMany(Trip::class, 'driver_id', 'driver_id');
    }
}
