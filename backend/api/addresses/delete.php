<?php
/**
 * Delete Address Endpoint
 * DELETE /api/addresses/delete.php?id={id}&user_id={user_id}
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE, GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Address.php';

$database = new Database();
$db = $database->getConnection();

$address = new Address($db);

// Get ID from query parameter
$address_id = isset($_GET['id']) ? $_GET['id'] : null;
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ($address_id && $user_id) {
    $address->AddressID = $address_id;
    $address->UserID = $user_id;

    if ($address->delete()) {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Address deleted successfully"
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to delete address"
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Address ID and User ID are required"
    ]);
}
?>
