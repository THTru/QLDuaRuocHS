<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LineType extends Model
{
    use HasFactory;

    protected $table='linetypes';
    protected $primaryKey='linetype_id';

    public function line(){
        return $this->hasMany(Line::class, 'linetype_id', 'linetype_id');
    }
}
