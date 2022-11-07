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
        Schema::create('lines', function (Blueprint $table) {
            $table->id('line_id');
            $table->string('line_name');
            $table->date('first_date');
            $table->date('last_date');
            $table->tinyInteger('slot');
            $table->tinyInteger('line_status');
            $table->dateTime('reg_deadline');
            $table->unsignedBigInteger('linetype_id');
            $table->unsignedBigInteger('vehicle_id')->nullable();
            $table->unsignedBigInteger('driver_id')->nullable();
            $table->unsignedBigInteger('carer_id')->nullable();
            $table->unsignedBigInteger('schedule_id');
            $table->timestamps();

            $table->foreign('linetype_id')->references('linetype_id')->on('linetypes')->onDelete('cascade');
            $table->foreign('vehicle_id')->references('vehicle_id')->on('vehicles')->onDelete('set null');
            $table->foreign('driver_id')->references('driver_id')->on('drivers')->onDelete('set null');
            $table->foreign('carer_id')->references('id')->on('users')->onDelete('set null');
            $table->foreign('schedule_id')->references('schedule_id')->on('schedules')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('lines');
    }
};
