<?php

/**
 * Abstract class representing a mail, to be implemented by subclasses
 */
abstract class AbstractMail {
    //Name of destinatary
    protected $from;
    //Name of sender
    protected $to;

    //Data about the commit/send request
    protected $title;
    protected $desc;

    public function __construct(string $from, string $to, string $typeCommit, string $idType, int $id) {
        global $db;
        //Gets title and description from the current commit/sendRequest
        $out = $db->preparedQuery("SELECT title, description FROM $typeCommit WHERE $idType=?", [$id])[0];
        $this->title = $out['title'];
        $this->desc = $out['description'];

        $this->from = $from;
        $this->to = $to;
        $this->typeCommit = $typeCommit;
    }
    
    //Subject of the mail
    public abstract function getSubject() : string;

    //Title, used in body
    public abstract function getTitle() : string;

    //Mail content
    public abstract function getContent() : string;

    //Builds a complete message
    public function getMsg() : string {
        global $gui_url;

        return "
        <html>
        <head>
            <title>". $this->getSubject() ."</title>
        </head>
        <body style='font-family: 'Arial', sans-serif;'>
            <h2>". $this->getTitle() ."</h2>
            " . $this->getContent() . "
            <p>Maggiori informazioni su <a href='$gui_url'>Authorization Manager</a></p>
        </body>
        </html>";
    }
}