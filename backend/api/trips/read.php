<?php
/**
 * Read User Trips Endpoint
 * GET /api/trips/read.php?user_id={id}
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Trip.php';

$database = new Database();
$db = $database->getConnection();

$trip = new Trip($db);

// Get user_id from query parameter
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ($user_id) {
    $trip->UserID = $user_id;
    $stmt = $trip->getUserTrips();
    $num = $stmt->rowCount();

    if ($num > 0) {
        $trips_arr = array();

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);

            $trip_item = array(
                "trip_id" => $TripID,
                "destination" => $Destination,
                "start_date" => $StartDate,
                "end_date" => $EndDate,
                "status" => $Status,
                "created_at" => $CreatedAt
            );

            array_push($trips_arr, $trip_item);
        }

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Trips retrieved successfully",
            "data" => $trips_arr
        ]);
    } else {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "No trips found",
            "data" => []
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "User ID is required"
    ]);
}
?>
