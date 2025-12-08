<?php
/**
 * Task Model
 * Handles task data operations
 */

class Task {
    private $conn;
    private $table_name = "Task";

    // Task properties
    public $TaskID;
    public $UserID;
    public $Title;
    public $Description;
    public $DueDate;
    public $Location;
    public $Latitude;
    public $Longitude;
    public $Status;
    public $CreatedAt;

    public function __construct($db) {
        $this->conn = $db;
    }

    /**
     * Get all tasks for a user
     */
    public function getUserTasks() {
        $query = "SELECT TaskID, Title, Description, DueDate, Location, Latitude, Longitude, Status, CreatedAt
                  FROM " . $this->table_name . "
                  WHERE UserID = :user_id
                  ORDER BY DueDate ASC, CreatedAt DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->execute();

        return $stmt;
    }

    /**
     * Create new task
     */
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  (UserID, Title, Description, DueDate, Location, Latitude, Longitude, Status)
                  VALUES (:user_id, :title, :description, :due_date, :location, :latitude, :longitude, :status)";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->Title = htmlspecialchars(strip_tags($this->Title));
        $this->Description = htmlspecialchars(strip_tags($this->Description));
        $this->Location = htmlspecialchars(strip_tags($this->Location));
        $this->Status = $this->Status ?? 'Pending';

        // Bind
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->bindParam(":title", $this->Title);
        $stmt->bindParam(":description", $this->Description);
        $stmt->bindParam(":due_date", $this->DueDate);
        $stmt->bindParam(":location", $this->Location);
        $stmt->bindParam(":latitude", $this->Latitude);
        $stmt->bindParam(":longitude", $this->Longitude);
        $stmt->bindParam(":status", $this->Status);

        if ($stmt->execute()) {
            $this->TaskID = $this->conn->lastInsertId();
            return true;
        }

        return false;
    }

    /**
     * Update task
     */
    public function update() {
        $query = "UPDATE " . $this->table_name . "
                  SET Title = :title,
                      Description = :description,
                      DueDate = :due_date,
                      Location = :location,
                      Latitude = :latitude,
                      Longitude = :longitude,
                      Status = :status
                  WHERE TaskID = :id AND UserID = :user_id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->Title = htmlspecialchars(strip_tags($this->Title));
        $this->Description = htmlspecialchars(strip_tags($this->Description));
        $this->Location = htmlspecialchars(strip_tags($this->Location));

        // Bind
        $stmt->bindParam(":title", $this->Title);
        $stmt->bindParam(":description", $this->Description);
        $stmt->bindParam(":due_date", $this->DueDate);
        $stmt->bindParam(":location", $this->Location);
        $stmt->bindParam(":latitude", $this->Latitude);
        $stmt->bindParam(":longitude", $this->Longitude);
        $stmt->bindParam(":status", $this->Status);
        $stmt->bindParam(":id", $this->TaskID);
        $stmt->bindParam(":user_id", $this->UserID);

        return $stmt->execute();
    }

    /**
     * Delete task
     */
    public function delete() {
        $query = "DELETE FROM " . $this->table_name . "
                  WHERE TaskID = :id AND UserID = :user_id";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":id", $this->TaskID);
        $stmt->bindParam(":user_id", $this->UserID);

        return $stmt->execute();
    }

    /**
     * Get task by ID
     */
    public function getById() {
        $query = "SELECT TaskID, UserID, Title, Description, DueDate, Location, Latitude, Longitude, Status, CreatedAt
                  FROM " . $this->table_name . "
                  WHERE TaskID = :id
                  LIMIT 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->TaskID);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $this->UserID = $row['UserID'];
            $this->Title = $row['Title'];
            $this->Description = $row['Description'];
            $this->DueDate = $row['DueDate'];
            $this->Location = $row['Location'];
            $this->Latitude = $row['Latitude'];
            $this->Longitude = $row['Longitude'];
            $this->Status = $row['Status'];
            $this->CreatedAt = $row['CreatedAt'];
            return true;
        }

        return false;
    }
}
?>
