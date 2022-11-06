<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Hclass extends Model
{
    use HasFactory;

    protected $table = 'classes';
    protected $primaryKey='class_id';
    protected $keyType='string';

    public function student(){
        return $this->hasMany(Student::class, 'class_id', 'class_id');
    }
}
