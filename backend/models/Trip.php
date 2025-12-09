<?php
/**
 * Trip Model
 * Handles trip data operations
 */

class Trip
{
    private $conn;
    private $table_name = "Trip";

    // Trip properties
    public $TripID;
    public $UserID;
    public $Destination;
    public $DestinationLatitude;
    public $DestinationLongitude;
    public $PickupLocation;
    public $PickupLatitude;
    public $PickupLongitude;
    public $TripDate;
    public $Status;
    public $CreatedAt;

    public function __construct($db)
    {
        $this->conn = $db;
    }

    /**
     * Get all trips for a user
     */
    public function getUserTrips()
    {
        $query = "SELECT TripID, Destination, DestinationLatitude, DestinationLongitude, 
                  PickupLocation, PickupLatitude, PickupLongitude, TripDate, Status, CreatedAt
                  FROM " . $this->table_name . "
                  WHERE UserID = :user_id
                  ORDER BY TripDate DESC, CreatedAt DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->execute();

        return $stmt;
    }

    /**
     * Create new trip
     */
    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . "
                  (UserID, Destination, DestinationLatitude, DestinationLongitude, 
                   PickupLocation, PickupLatitude, PickupLongitude, TripDate, Status)
                  VALUES (:user_id, :destination, :dest_lat, :dest_lng, 
                          :pickup_location, :pickup_lat, :pickup_lng, :trip_date, :status)";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->Destination = htmlspecialchars(strip_tags($this->Destination));
        $this->PickupLocation = htmlspecialchars(strip_tags($this->PickupLocation));
        $this->Status = $this->Status ?? 'Planned';

        // Bind
        $stmt->bindParam(":user_id", $this->UserID);
        $stmt->bindParam(":destination", $this->Destination);
        $stmt->bindParam(":dest_lat", $this->DestinationLatitude);
        $stmt->bindParam(":dest_lng", $this->DestinationLongitude);
        $stmt->bindParam(":pickup_location", $this->PickupLocation);
        $stmt->bindParam(":pickup_lat", $this->PickupLatitude);
        $stmt->bindParam(":pickup_lng", $this->PickupLongitude);
        $stmt->bindParam(":trip_date", $this->TripDate);
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
    public function update()
    {
        $query = "UPDATE " . $this->table_name . "
                  SET Destination = :destination,
                      DestinationLatitude = :dest_lat,
                      DestinationLongitude = :dest_lng,
                      PickupLocation = :pickup_location,
                      PickupLatitude = :pickup_lat,
                      PickupLongitude = :pickup_lng,
                      TripDate = :trip_date,
                      Status = :status
                  WHERE TripID = :id AND UserID = :user_id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->Destination = htmlspecialchars(strip_tags($this->Destination));
        $this->PickupLocation = htmlspecialchars(strip_tags($this->PickupLocation));

        // Bind
        $stmt->bindParam(":destination", $this->Destination);
        $stmt->bindParam(":dest_lat", $this->DestinationLatitude);
        $stmt->bindParam(":dest_lng", $this->DestinationLongitude);
        $stmt->bindParam(":pickup_location", $this->PickupLocation);
        $stmt->bindParam(":pickup_lat", $this->PickupLatitude);
        $stmt->bindParam(":pickup_lng", $this->PickupLongitude);
        $stmt->bindParam(":trip_date", $this->TripDate);
        $stmt->bindParam(":status", $this->Status);
        $stmt->bindParam(":id", $this->TripID);
        $stmt->bindParam(":user_id", $this->UserID);

        return $stmt->execute();
    }

    /**
     * Delete trip
     */
    public function delete()
    {
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
    public function getById()
    {
        $query = "SELECT TripID, UserID, Destination, DestinationLatitude, DestinationLongitude,
                  PickupLocation, PickupLatitude, PickupLongitude, TripDate, Status, CreatedAt
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
            $this->DestinationLatitude = $row['DestinationLatitude'];
            $this->DestinationLongitude = $row['DestinationLongitude'];
            $this->PickupLocation = $row['PickupLocation'];
            $this->PickupLatitude = $row['PickupLatitude'];
            $this->PickupLongitude = $row['PickupLongitude'];
            $this->TripDate = $row['TripDate'];
            $this->Status = $row['Status'];
            $this->CreatedAt = $row['CreatedAt'];
            return true;
        }

        return false;
    }
}
?>