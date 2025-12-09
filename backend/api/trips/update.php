<?php
/**
 * Update Trip Endpoint
 * PUT /api/trips/update.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: PUT");
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
    !empty($data->trip_id) &&
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
    $trip->TripID = $data->trip_id;
    $trip->UserID = $data->user_id;
    $trip->Destination = $data->destination;
    $trip->DestinationLatitude = $data->destination_latitude;
    $trip->DestinationLongitude = $data->destination_longitude;
    $trip->PickupLocation = $data->pickup_location;
    $trip->PickupLatitude = $data->pickup_latitude;
    $trip->PickupLongitude = $data->pickup_longitude;
    $trip->TripDate = $data->trip_date;
    $trip->Status = $data->status;

    // Update trip
    if ($trip->update()) {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Trip updated successfully!"
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to update trip. Please try again."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Unable to update trip. Required fields are missing."
    ]);
}
?>