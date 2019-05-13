<?php

/**
 * Mail used to communicate that there's a new send request to Revision Office members
 */
class ReqApprovedMail extends AbstractMail {
    private $author;

    public function __construct(string $from, string $to, string $typeCommit, string $idType, int $id) {
        parent::__construct($from, $to, $typeCommit, $idType, $id);
        global $db;

        //Get the original author (the programmer)
        $this->author = $db->preparedQuery("SELECT name FROM users, requests WHERE author_user_id=user_id AND request_id=?", [$id])[0]['name'];
    }

    public function getSubject() : string {
        return "AUM - Nuova richiesta di invio approvata da " . $this->from;
    }

    public function getTitle() : string {
        return "$this->from ha approvato una nuova richiesta di invio";
    }
    
    public function getContent() : string {
        return "
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            <tr><td><b>Autore: </b></td><td>$this->author</td></tr>
            <tr><td><b>Approvata da: </b></td><td>$this->from</td></tr>
            </table>";
    }
}