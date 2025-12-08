<?php
/**
 * Create Trip Endpoint
 * POST /api/trips/create.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Trip.php';

$database = new Database();
$db = $database->getConnection();

$trip = new Trip($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Validate required fields
if (
    !empty($data->user_id) &&
    !empty($data->destination) &&
    !empty($data->start_date)
) {
    // Set trip properties
    $trip->UserID = $data->user_id;
    $trip->Destination = $data->destination;
    $trip->StartDate = $data->start_date;
    $trip->EndDate = isset($data->end_date) ? $data->end_date : null;
    $trip->Status = isset($data->status) ? $data->status : 'Planned';

    // Create trip
    if ($trip->create()) {
        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "Trip created successfully!",
            "data" => [
                "trip_id" => $trip->TripID,
                "destination" => $trip->Destination,
                "start_date" => $trip->StartDate,
                "end_date" => $trip->EndDate,
                "status" => $trip->Status
            ]
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to create trip. Please try again."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Unable to create trip. Destination and start date are required."
    ]);
}
?>
