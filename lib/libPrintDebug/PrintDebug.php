<?php

/**
 * Class used for debug purposes, enabled only in developer builds
 */
class PrintDebug {
    private $debug_flag;

    public function __construct(bool $is_debug = false) {
        $this->debug_flag = $is_debug;
    }

    /**
     * Check if this environment is a debug one or production
     * @return bool true if debug mode
     */
    public function isDebug() : bool {
        return $this->debug_flag;
    }

    /**
     * Prints on body/CLI some debug string, given that we are in debug mode
     * @param string $input String you want to print
     */
    public function printDebug(string $input) {
        if($this->debug_flag)
            print($input);
    }

    /**
     * Prints on the JSON response, given that we are in debug mode
     * @param string $input String you want to print
     */
    public function printDebugJSON(array $input) {
        global $response;

        if ($this->debug_flag)
            $response['debug'][] = $input;    
    }

    /**
     * Prints on body/CLI some debug string, given that we are in debug mode
     * @param string $input String you want to print
     * @return string '$input' if debug_flag=true, "" otherwise
     */
    public function getDebugString(string $input) : string {
        return $this->debug_flag ? $input : "";
    }

    public function getDebugArray(array $input) : array {
        return ( $this->debug_flag ? $input : []);
    }
}