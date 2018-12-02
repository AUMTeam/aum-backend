<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/12
 * Time: 21:38
 */

class InvalidTokenException extends ExceptionRequest
{
    public function __construct(string $message, int $error_code = 101, int $status_code = 401)
    {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array
    {
        return parent::getErrorResponse();
    }
}