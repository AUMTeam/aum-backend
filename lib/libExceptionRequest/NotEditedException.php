<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 12/11/2018
 * Time: 17:21
 */

class NotEditedException extends ExceptionRequest {
    public function __construct(string $message = "", int $error_code = 3008, int $status_code = 304)
    {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array
    {
        return parent::getErrorResponse();
    }
}