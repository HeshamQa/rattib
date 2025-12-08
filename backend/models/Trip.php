<?php
/**
 * Trip Model
 * Handles trip data operations
 */

class Trip {
    private $conn;
    private $table_name = "Trip";

    // Trip properties
    public $TripID;
    public $UserID;
    public $Destination;
    public $StartDate;
    public $EndDate;
    public $Status;
    public $CreatedAt;

    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Get all trips for a user
     */
    public function getUserTrips() {
        $query = "SELECT TripID, Destination, StartDate, EndDate, Status, CreatedAt
                  FROM " . $this->table_name . "
                  WHERE UserID = :user_id
                  ORDER BY StartDate DESC, CreatedAt DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->execute();

        return $stmt;
    }

    /**
     * Create new trip
     */
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  (UserID, Destination, StartDate, EndDate, Status)
                  VALUES (:user_id, :destination, :start_date, :end_date, :status)";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->Destination = htmlspecialchars(strip_tags($this->Destination));
        $this->Status = $this->Status ?? 'Planned';

        // Bind
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->bindParam(":destination", $this->Destination);
        $stmt->bindParam(":start_date", $this->StartDate);
        $stmt->bindParam(":end_date", $this->EndDate);
        $stmt->bindParam(":status", $this->Status);

        if ($stmt->execute()) {
            $this->TripID = $this->conn->lastInsertId();
            return true;
        }

        return false;
    }

    /**
     * Update trip
     */
    public function update() {
        $query = "UPDATE " . $this->table_name . "
                  SET Destination = :destination,
                      StartDate = :start_date,
                      EndDate = :end_date,
                      Status = :status
                  WHERE TripID = :id AND UserID = :user_id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->Destination = htmlspecialchars(strip_tags($this->Destination));

        // Bind
        $stmt->bindParam(":destination", $this->Destination);
        $stmt->bindParam(":start_date", $this->StartDate);
        $stmt->bindParam(":end_date", $this->EndDate);
        $stmt->bindParam(":status", $this->Status);
        $stmt->bindParam(":id", $this->TripID);
        $stmt->bindParam(":user_id", $this->UserID);

        return $stmt->execute();
    }

    /**
     * Delete trip
     */
    public function delete() {
        $query = "DELETE FROM " . $this->table_name . "
                  WHERE TripID = :id AND UserID = :user_id";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":id", $this->TripID);
        $stmt->bindParam(":user_id", $this->UserID);

        return $stmt->execute();
    }

    /**
     * Get trip by ID
     */
    public function getById() {
        $query = "SELECT TripID, UserID, Destination, StartDate, EndDate, Status, CreatedAt
                  FROM " . $this->table_name . "
                  WHERE TripID = :id
                  LIMIT 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->TripID);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $this->UserID = $row['UserID'];
            $this->Destination = $row['Destination'];
            $this->StartDate = $row['StartDate'];
            $this->EndDate = $row['EndDate'];
            $this->Status = $row['Status'];
            $this->CreatedAt = $row['CreatedAt'];
            return true;
        }

        return false;
    }
}
?>
