<?php

class NewCommitMail extends AbstractMail {
    private $commitTitle;

    public function __construct(string $from, string $to, int $commit_id) {
        parent::__construct();
        global $db;
        $this->commitTitle = $db->query("SELECT description FROM commits WHERE commit_id=$commit_id")[0]['description'];
    }

    public function getSubject() : string {
        return "AUM - Nuovo Commit da " . $to;
    }

    public function getTitle() : string {
        return "Un nuovo commit è stato pubblicato!";
    }
    
    public function getContent() : string {
        return "
            <h4>Contenuto:</h4>
            <p>Titolo: <i>$commitTitle</i><br>
               Autore: <i>$to</i></p>";
    }
}