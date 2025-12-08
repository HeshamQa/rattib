<?php
/**
 * Address Model
 * Handles address data operations
 */

class Address {
    private $conn;
    private $table_name = "Address";

    // Address properties
    public $AddressID;
    public $UserID;
    public $AddressType;
    public $AddressLine;
    public $Latitude;
    public $Longitude;
    public $CreatedAt;

    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Get all addresses for a user
     */
    public function getUserAddresses() {
        $query = "SELECT AddressID, AddressType, AddressLine, Latitude, Longitude, CreatedAt
                  FROM " . $this->table_name . "
                  WHERE UserID = :user_id
                  ORDER BY CreatedAt DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->execute();

        return $stmt;
    }

    /**
     * Create new address
     */
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  (UserID, AddressType, AddressLine, Latitude, Longitude)
                  VALUES (:user_id, :address_type, :address_line, :latitude, :longitude)";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->AddressType = htmlspecialchars(strip_tags($this->AddressType));
        $this->AddressLine = htmlspecialchars(strip_tags($this->AddressLine));

        // Bind
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->bindParam(":address_type", $this->AddressType);
        $stmt->bindParam(":address_line", $this->AddressLine);
        $stmt->bindParam(":latitude", $this->Latitude);
        $stmt->bindParam(":longitude", $this->Longitude);

        if ($stmt->execute()) {
            $this->AddressID = $this->conn->lastInsertId();
            return true;
        }

        return false;
    }

    /**
     * Delete address
     */
    public function delete() {
        $query = "DELETE FROM " . $this->table_name . "
                  WHERE AddressID = :id AND UserID = :user_id";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":id", $this->AddressID);
        $stmt->bindParam(":user_id", $this->UserID);

        return $stmt->execute();
    }

    /**
     * Get address by ID
     */
    public function getById() {
        $query = "SELECT AddressID, UserID, AddressType, AddressLine, Latitude, Longitude, CreatedAt
                  FROM " . $this->table_name . "
                  WHERE AddressID = :id
                  LIMIT 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->AddressID);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $this->UserID = $row['UserID'];
            $this->AddressType = $row['AddressType'];
            $this->AddressLine = $row['AddressLine'];
            $this->Latitude = $row['Latitude'];
            $this->Longitude = $row['Longitude'];
            $this->CreatedAt = $row['CreatedAt'];
            return true;
        }

        return false;
    }
}
?>
