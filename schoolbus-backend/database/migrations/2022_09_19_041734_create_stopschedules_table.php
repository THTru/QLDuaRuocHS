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
        Schema::create('stopschedules', function (Blueprint $table) {
            $table->id('stopschedule_id');
            $table->unsignedBigInteger('stop_id');
            $table->unsignedBigInteger('schedule_id');
            $table->tinyInteger('order');
            $table->timestamps();

            $table->foreign('stop_id')->references('stop_id')->on('stops');
            $table->foreign('schedule_id')->references('schedule_id')->on('schedules');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('stopschedules');
    }
};
