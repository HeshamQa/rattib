<?php
/**
 * Delete Trip Endpoint
 * DELETE /api/trips/delete.php?id={trip_id}&user_id={user_id}
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Trip.php';

$database = new Database();
$db = $database->getConnection();

$trip = new Trip($db);

// Get query parameters
$trip_id = isset($_GET['id']) ? $_GET['id'] : null;
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ($trip_id && $user_id) {
    $trip->TripID = $trip_id;
    $trip->UserID = $user_id;

    if ($trip->delete()) {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Trip deleted successfully!"
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to delete trip. Please try again."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Trip ID and User ID are required"
    ]);
}
?>
