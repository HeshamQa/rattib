<?php
/**
 * Create Address Endpoint
 * POST /api/addresses/create.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Address.php';

$database = new Database();
$db = $database->getConnection();

$address = new Address($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Validate required fields
if (
    !empty($data->user_id) &&
    !empty($data->address_type) &&
    !empty($data->address_line)
) {
    // Set address properties
    $address->UserID = $data->user_id;
    $address->AddressType = $data->address_type;
    $address->AddressLine = $data->address_line;
    $address->Latitude = isset($data->latitude) ? $data->latitude : null;
    $address->Longitude = isset($data->longitude) ? $data->longitude : null;

    // Create address
    if ($address->create()) {
        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "Address created successfully!",
            "data" => [
                "address_id" => $address->AddressID,
                "address_type" => $address->AddressType,
                "address_line" => $address->AddressLine,
                "latitude" => $address->Latitude,
                "longitude" => $address->Longitude
            ]
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to create address. Please try again."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Unable to create address. Required fields are missing."
    ]);
}
?>
