<?php

class DatabaseWrapper {
    private $handler;

    public function __construct(string $db_type, array $config) {
        $options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_WARNING];

        try {
            if (array_key_exists("db_name", $config)) {
                if ($db_type == "sqlite") {
                    $this->handler = new PDO("{$db_type}:{$config['db_name']}", $options);
                } else if (array_key_exists("server", $config) && array_key_exists("username", $config) && array_key_exists("password", $config)) {
                    $this->handler = new PDO("{$db_type}:host={$config['server']};dbname={$config['db_name']}", $config['username'], $config['password'], $options);
                }
            }
        } catch (PDOException $e) {
            throw new Exception("Error connecting to the database using PDO: " . $e->getMessage());
        }
    }

    public function query(string $query) {
        try {
            $result = $this->handler->query($query);
            $out = [];

            foreach($result as $row)
                $out[] = $row;

            return $out;
        } catch (PDOException $e) {
            throw new Exception("Error in executing query '$query' : ". $e->getMessage());
        }
    }

    public function __destruct() {
        $this->handler = null;
    }
}