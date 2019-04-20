<?php

//Fatal error handling
function envi_error_catcher($errno, $errstr, $errfile, $errline) {
    global $printDebug;

    $out = [
        "message" => "A Fatal error was triggered from server."
    ];

    //Detailed message error on response in case of debug mode
    if($printDebug->isDebug()) {
        $out['dev_message'] = [
            "error_number" => $errno,
            "error_string" => $errstr,
            "error_line" => $errline,
            "error_file" => $errfile,
            "error_message" => "Custom error: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    } else {
        file_put_contents(__DIR__ . "/log/Error_" . date("d-m-y") . ".log", time() . "Custom error: [$errno] $errstr. Error on line $errline in $errfile");
    }

    $fp=fopen("php://output","w");
    fwrite($fp,json_encode($out));
    die(fclose($fp));
}

function envi_shutdown_catcher() {
    global $printDebug;

    if($printDebug->isDebug()) {
        $out = [
            'message' => "Shutdown function called"
        ];
    }
}

function envi_warning_catcher($errno, $errstr, $errfile, $errline) {
    global $printDebug;
    global $warnings;

    if($printDebug->isDebug()) {
        $warnings[] = [
            "warning" => "Warning triggered: Error on line $errline in $errfile",
            "dev_message" => "Warning triggered: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    } else {
        file_put_contents(__DIR__ . "/log/Warning_" . date("d-m-y") . ".log", time() . "Warning triggered: [$errno] $errstr. Error on line $errline in $errfile");
    }
}

function envi_notice_catcher($errno, $errstr, $errfile, $errline) {
    global $printDebug;
    global $warnings;

    if($printDebug->isDebug()) {
        $warnings[] = [
            "warning" => "Notice triggered: Error on line $errline in $errfile",
            "dev_message" => "Notice triggered: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    } else {
        file_put_contents(__DIR__ . "/log/Notice_" . date("d-m-y") . ".log", time() . "Notice triggered: [$errno] $errstr. Error on line $errline in $errfile");
    }
}