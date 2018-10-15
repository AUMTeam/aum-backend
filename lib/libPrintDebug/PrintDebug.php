<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/12
 * Time: 19:10
 */

class PrintDebug
{
    private $debug_flag;

    public function __construct(bool $is_debug = false)
    {
        $this->debug_flag = $is_debug;
    }

    public function printDebug(string $input){
        if($this->debug_flag)
            print($input);
    }

    public function getDebugString(string $input) : string {
        if($this->debug_flag)
            return $input;
        else
            return "";
    }
}