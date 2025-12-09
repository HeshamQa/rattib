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
    isset($data->destination_latitude) &&
    isset($data->destination_longitude) &&
    !empty($data->pickup_location) &&
    isset($data->pickup_latitude) &&
    isset($data->pickup_longitude) &&
    !empty($data->trip_date)
) {
    // Set trip properties
    $trip->UserID = $data->user_id;
    $trip->Destination = $data->destination;
    $trip->DestinationLatitude = $data->destination_latitude;
    $trip->DestinationLongitude = $data->destination_longitude;
    $trip->PickupLocation = $data->pickup_location;
    $trip->PickupLatitude = $data->pickup_latitude;
    $trip->PickupLongitude = $data->pickup_longitude;
    $trip->TripDate = $data->trip_date;
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
                "destination_latitude" => $trip->DestinationLatitude,
                "destination_longitude" => $trip->DestinationLongitude,
                "pickup_location" => $trip->PickupLocation,
                "pickup_latitude" => $trip->PickupLatitude,
                "pickup_longitude" => $trip->PickupLongitude,
                "trip_date" => $trip->TripDate,
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
        "message" => "Unable to create trip. All location fields and trip date are required."
    ]);
}
?>