<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 15:26
 */

class InvalidRequestException extends ExceptionRequest {

    public function __construct(string $message, int $error_code = 104, int $status_code = 400)
    {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array
    {
        return parent::getErrorResponse();
    }
}