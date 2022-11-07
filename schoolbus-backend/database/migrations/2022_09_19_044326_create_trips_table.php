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
            $table->string('note')->nullable();
            $table->unsignedBigInteger('line_id');
            $table->unsignedBigInteger('vehicle_id')->nullable();
            $table->unsignedBigInteger('driver_id')->nullable();
            $table->unsignedBigInteger('carer_id')->nullable();
            $table->timestamps();

            $table->foreign('line_id')->references('line_id')->on('lines')->onDelete('cascade');
            $table->foreign('vehicle_id')->references('vehicle_id')->on('vehicles')->onDelete('set null');
            $table->foreign('driver_id')->references('driver_id')->on('drivers')->onDelete('set null');
            $table->foreign('carer_id')->references('id')->on('users')->onDelete('set null');
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
