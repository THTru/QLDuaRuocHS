<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('trips', function (Blueprint $table) {
            $table->id('trip_id');
            $table->string('trip_name');
            $table->date('date');
            $table->time('start_at');
            $table->time('end_at');
            $table->string('note');
            $table->unsignedBigInteger('line_id');
            $table->unsignedBigInteger('vehicle_id');
            $table->unsignedBigInteger('driver_id');
            $table->unsignedBigInteger('carer_id');
            $table->timestamps();

            $table->foreign('line_id')->references('line_id')->on('lines');
            $table->foreign('vehicle_id')->references('vehicle_id')->on('vehicles');
            $table->foreign('driver_id')->references('driver_id')->on('drivers');
            $table->foreign('carer_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('trips');
    }
};
