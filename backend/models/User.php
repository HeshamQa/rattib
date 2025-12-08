<?php
/**
 * User Model
 * Handles user data operations
 */

class User {
    private $conn;
    private $table_name = "Users";

    // User properties
    public $UserID;
    public $Name;
    public $Email;
    public $Password;
    public $JoinDate;

    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Create new user
     */
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  (Name, Email, Password)
                  VALUES (:name, :email, :password)";

        $stmt = $this->conn->prepare($query);

        // Sanitize inputs
        $this->Name = htmlspecialchars(strip_tags($this->Name));
        $this->Email = htmlspecialchars(strip_tags($this->Email));

        // Hash password
        $hashed_password = password_hash($this->Password, PASSWORD_BCRYPT);

        // Bind parameters
        $stmt->bindParam(":name", $this->Name);
        $stmt->bindParam(":email", $this->Email);
        $stmt->bindParam(":password", $hashed_password);

        if ($stmt->execute()) {
            $this->UserID = $this->conn->lastInsertId();
            return true;
        }

        return false;
    }

    /**
     * Login user
     */
    public function login() {
        $query = "SELECT UserID, Name, Email, Password
                  FROM " . $this->table_name . "
                  WHERE Email = :email
                  LIMIT 1";

        $stmt = $this->conn->prepare($query);

        // Sanitize email
        $this->Email = htmlspecialchars(strip_tags($this->Email));

        $stmt->bindParam(":email", $this->Email);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            // Verify password
            if (password_verify($this->Password, $row['Password'])) {
                $this->UserID = $row['UserID'];
                $this->Name = $row['Name'];
                $this->Email = $row['Email'];
                return true;
            }
        }

        return false;
    }

    /**
     * Check if email exists
     */
    public function emailExists() {
        $query = "SELECT UserID, Name, Email
                  FROM " . $this->table_name . "
                  WHERE Email = :email
                  LIMIT 1";

        $stmt = $this->conn->prepare($query);

        $this->Email = htmlspecialchars(strip_tags($this->Email));
        $stmt->bindParam(":email", $this->Email);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $this->UserID = $row['UserID'];
            $this->Name = $row['Name'];
            $this->Email = $row['Email'];
            return true;
        }

        return false;
    }

    /**
     * Get user by ID
     */
    public function getById() {
        $query = "SELECT UserID, Name, Email, JoinDate
                  FROM " . $this->table_name . "
                  WHERE UserID = :id
                  LIMIT 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->UserID);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $this->Name = $row['Name'];
            $this->Email = $row['Email'];
            $this->JoinDate = $row['JoinDate'];
            return true;
        }

        return false;
    }

    /**
     * Update user
     */
    public function update() {
        $query = "UPDATE " . $this->table_name . "
                  SET Name = :name, Email = :email
                  WHERE UserID = :id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->Name = htmlspecialchars(strip_tags($this->Name));
        $this->Email = htmlspecialchars(strip_tags($this->Email));

        // Bind
        $stmt->bindParam(":name", $this->Name);
        $stmt->bindParam(":email", $this->Email);
        $stmt->bindParam(":id", $this->UserID);

        return $stmt->execute();
    }

    /**
     * Update password
     */
    public function updatePassword() {
        $query = "UPDATE " . $this->table_name . "
                  SET Password = :password
                  WHERE UserID = :id";

        $stmt = $this->conn->prepare($query);

        $hashed_password = password_hash($this->Password, PASSWORD_BCRYPT);

        $stmt->bindParam(":password", $hashed_password);
        $stmt->bindParam(":id", $this->UserID);

        return $stmt->execute();
    }
}
?>
