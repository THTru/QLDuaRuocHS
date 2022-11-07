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
        Schema::create('registrations', function (Blueprint $table) {
            $table->id('reg_id');
            $table->dateTime('reg_time');
            $table->string('student_id');
            $table->unsignedBigInteger('line_id');
            $table->unsignedBigInteger('stop_id');
            $table->timestamps();

            $table->foreign('student_id')->references('student_id')->on('students')->onDelete('cascade');
            $table->foreign('line_id')->references('line_id')->on('lines')->onDelete('cascade');
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
        Schema::dropIfExists('registrations');
    }
};
