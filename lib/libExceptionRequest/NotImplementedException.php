<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 15:58
 */

class NotImplementedException extends ExceptionRequest
{

    public function __construct(string $message, int $error_code = 102, int $status_code = 404)
    {
        parent::__construct($message, $error_code, $status_code);
    }

    public function getErrorResponse() : array
    {
        return parent::getErrorResponse();
    }

}