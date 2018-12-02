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

    /**
     * It let you know if this environment is a debug one or production
     * @return bool true if debug mode
     */
    public function isDebug() : bool {
        return $this->debug_flag;
    }

    /**
     * It let you print on body/CLI some debug strings
     * @param string $input string you want to show only on debug mode
     */
    public function printDebug(string $input){
        if($this->debug_flag)
            print($input);
    }

    /**
     * It let you write a string with something if this environment is set to be a debug one
     * @param string $input string you want to show only on debug mode
     * @return string what you put in if on debug mode, otherwise an empty string.
     */
    public function getDebugString(string $input) : string {
        return $this->debug_flag ? $input : "";
    }

    public function getDebugArray(array $input) : array {
        return ( $this->debug_flag ? $input : []);
    }
}