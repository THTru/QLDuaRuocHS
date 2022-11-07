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
        Schema::create('linetypes', function (Blueprint $table) {
            $table->id('linetype_id');
            $table->string('linetype_name');
            $table->tinyInteger('is_back');
            $table->time('time_start');
            $table->time('time_end');
            $table->tinyInteger('mon')->default('1');
            $table->tinyInteger('tue')->default('1');
            $table->tinyInteger('wed')->default('1');
            $table->tinyInteger('thu')->default('1');
            $table->tinyInteger('fri')->default('1');
            $table->tinyInteger('sat')->default('0');
            $table->tinyInteger('sun')->default('0');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('linetypes');
    }
};
