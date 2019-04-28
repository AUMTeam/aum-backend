<?php

/**
 * Abstract class representing a mail, to be implemented by subclasses
 */
abstract class AbstractMail {
    //Name of destinatary
    protected $from;
    //Name of sender
    protected $to;

    public function __construct(string $from, string $to) {
        $this->from = $from;
        $this->to = $to;
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
            <p>Maggiori informazioni <a href='$gui_url'>sul sito di AUM</a></p>
        </body>
        </html>";
    }
}