<?php

/**
 * Class used to communicate to the DataBase
 */
class DatabaseWrapper {
    //PDO object
    private $handler;

    //Istantiate the PDO object using values from 'config.php' file
    public function __construct(string $db_type, array $config) {
        $options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_EMULATE_PREPARES => false];

        try {
            if ($db_type == "sqlite")
                $this->handler = new PDO("{$db_type}:{$config['db_name']}", $options);
            else if ($db_type == "mysql")
                $this->handler = new PDO("{$db_type}:host={$config['server']}; dbname={$config['db_name']}; charset=utf8mb4", $config['username'], $config['password'], $options);
            else if ($db_type == "pgsql")
                $this->handler = new PDO("{$db_type}:host={$config['server']}; port={$config['port']}; dbname={$config['db_name']};
                    user={$config['username']}; password={$config['password']}", $config['username'], $config['password'], $options);
        } catch (PDOException $e) {
            throw new DBException("Error connecting to the database using PDO: " . $e->getMessage());
        }
        $this->handler->exec("SET NAMES 'utf8';");
    }

    //Executes a parametrized query, SQL Injection Safe
    public function preparedQuery(string $query, array $params = null) {
        try {
            $out = null;
            $stmt = $this->handler->prepare($query);

            if ($params != null) {
                //Bind the params with their respective data types
                for($i=0;$i<count($params); $i++) {
                    $elem = $params[$i];
                    $type = PDO::PARAM_STR;

                    if (is_string($elem) || is_float($elem))    //PARAM_FLOAT is not supported
                        $type = PDO::PARAM_STR;
                    else if (is_int($elem))
                        $type = PDO::PARAM_INT;
                    else if (is_bool($elem))
                        $type = PDO::PARAM_BOOL;

                    $stmt->bindParam($i+1, $elem, $type);
                }
            } else
                $params = [];

            //Execute the query
            $stmt->execute($params);

            //We need to get results only from SELECT queries
            if (strpos($query, "SELECT") !== false)
                $out = $stmt->fetchAll(PDO::FETCH_ASSOC);

            return $out;
        
        } catch(PDOException $ex) {
            //Print the exception in the JSON response
            throw new DBException("Error in executing query: '$query' -- Message: " . $ex->getMessage());
        }
    }

    public function getLastInsertId(string $name = NULL) : string {
        return $this->handler->lastInsertId($name);
    }

    public function beginTransaction() : bool {
        return $this->handler->beginTransaction();
    }

    public function commit() {
        return $this->handler->commit();
    }

    public function rollback() {
        return $this->handler->rollback();
    }

    public function __destruct() {
        $this->handler = null;
    }
}