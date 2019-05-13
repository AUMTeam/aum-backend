<?php

/**
 * Mail used to communicate that a send request was sent to the clients
 */
class PatchSentMail extends AbstractMail {
    private $clients;
    private $author;
    private $approver;

    public function __construct(string $from, string $to, string $typeCommit, string $idType, int $id) {
        parent::__construct($from, $to, $typeCommit, $idType, $id);
        global $db;

        //Get the clients list
        $this->clients = $db->preparedQuery("SELECT name FROM users, requests_clients WHERE client_user_id=user_id AND request_id=?", [$id]);
        //Get the original author (the programmer)
        $this->author = $db->preparedQuery("SELECT name FROM users, requests WHERE author_user_id=user_id AND request_id=?", [$id])[0]['name'];
        //Get the approver
        $this->approver = $db->preparedQuery("SELECT name FROM users, requests WHERE approver_user_id=user_id AND request_id=?", [$id])[0]['name'];
    }

    public function getSubject() : string {
        return "AUM - Patch inviata da " . $this->from;
    }

    public function getTitle() : string {
        return "$this->from ha appena inviato un aggiornamento";
    }
    
    public function getContent() : string {
        $cliList = "";
        foreach($this->clients as $client)
            $cliList .= $client['name'] . ", ";
        $cliList = substr($cliList, 0, -2); //Remove last ', '
        
        return "
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            <tr></tr>
            <tr><td><b>Autore: </b></td><td>$this->author</td></tr>
            <tr><td><b>Approvata da: </b></td><td>$this->approver</td></tr>
            <tr><td><b>Clienti destinatari: </b></td><td> " . $cliList ."</td></tr>
            </table>";
    }
}