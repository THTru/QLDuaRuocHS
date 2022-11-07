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
        Schema::create('studenttrips', function (Blueprint $table) {
            $table->id('studenttrip_id');
            $table->string('student_id');
            $table->unsignedBigInteger('trip_id');
            $table->unsignedBigInteger('stop_id');
            $table->time('est_time')->nullable();
            $table->time('on_at')->nullable();
            $table->time('off_at')->nullable();
            $table->tinyInteger('absence');
            $table->tinyInteger('absence_req');
            $table->timestamps();

            $table->foreign('student_id')->references('student_id')->on('students')->onDelete('cascade');
            $table->foreign('trip_id')->references('trip_id')->on('trips')->onDelete('cascade');
            $table->foreign('stop_id')->references('stop_id')->on('stops')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('studenttrips');
    }
};
