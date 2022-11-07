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
        Schema::create('students', function (Blueprint $table) {
            $table->string('student_id');
            $table->string('student_name');
            $table->string('avatar')->nullable();
            $table->unsignedBigInteger('parent_id')->nullable();
            $table->string('class_id')->nullable();
            $table->timestamps();

            $table->primary('student_id');
            $table->foreign('parent_id')->references('id')->on('users')->onDelete('set null');
            $table->foreign('class_id')->references('class_id')->on('classes')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('students');
    }
};
