<?php

abstract class AbstractMail {
    //Name of destinatary
    protected $from;
    //Name of sender
    protected $to;
    protected $commit_id;

    public function __construct(string $from, string $to, $commit_id = null) {
        $this->from = $from;
        $this->to = $to;
        if ($commit_id != null)
            $this->commit_id = $commit_id;
    }
    
    public abstract function getSubject() : string;

    public abstract function getTitle() : string;

    public abstract function getContent() : string;

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