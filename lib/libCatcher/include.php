<?php

include_once "./../../config.php";

if(!isset($printDebug))
    $printDebug = new class(!$debug_mode){
        private $release_mode;

        public function __construct($release_mode = true){
            $this->release_mode = $release_mode;
        }

        public function isDebug() : bool {
            return $this->release_mode;
        }
    };

//Fatal error handling
function envi_error_catcher($errno, $errstr, $errfile, $errline) {

    global $printDebug;

    $out = [
        "message" => "A Fatal error was triggered from server."
    ];

    //Detailed message error on response in case of debug mode
    if($printDebug->isDebug()){
        $out['dev_message'] = [
            "error_number" => $errno,
            "error_string" => $errstr,
            "error_line" => $errline,
            "error_file" => $errfile,
            "error_message" => "Custom error: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    }else{
        file_put_contents(__DIR__ . "/log/Strict_" . time() . ".log", "Custom error: [$errno] $errstr. Error on line $errline in $errfile");
    }

    $fp=fopen("php://output","w");
    fwrite($fp,json_encode($out));
    die(fclose($fp));
}

function envi_shutdown_catcher(){

    global $printDebug;

    $out = [
        'message' => "Shutdown function called"
    ];

    //TODO DEBUG PRINT

    die(json_encode($out));
}

function envi_warning_catcher($errno, $errstr, $errfile, $errline){

    global $printDebug;
    global $warnings;

    if($printDebug->isDebug()){
        $warnings[] = [
            "warning" => "Warning triggered: Error on line $errline in $errfile",
            "dev_message" => "Warning triggered: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    }else{
        file_put_contents(__DIR__ . "/log/Warning_" . time() . ".log", "Warning triggered: [$errno] $errstr. Error on line $errline in $errfile");
    }

}

function envi_notice_catcher($errno, $errstr, $errfile, $errline){

    global $printDebug;
    global $warnings;

    if($printDebug->isDebug()){
        $warnings[] = [
            "warning" => "Notice triggered: Error on line $errline in $errfile",
            "dev_message" => "Notice triggered: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    }else{
        file_put_contents(__DIR__ . "/log/Notice_" . time() . ".log", "Notice triggered: [$errno] $errstr. Error on line $errline in $errfile");
    }

}