<?php
/**
 * Database Configuration File
 * Rattib Mashawerak API
 *
 * This file contains database connection settings
 */

class Database {
    // Database credentials
    private $host = "localhost";
    private $db_name = "softvysc_rattib";
    private $username = "softvysc_rattib_user"; // Update with your database username
    private $password = ""; // Update with your database password
    public $conn;

    // Get database connection
    public function getConnection() {
        $this->conn = null;

        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name,
                $this->username,
                $this->password
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->exec("set names utf8mb4");
        } catch(PDOException $exception) {
            echo json_encode([
                "success" => false,
                "message" => "Connection error: " . $exception->getMessage()
            ]);
            exit;
        }

        return $this->conn;
    }
}
?>
