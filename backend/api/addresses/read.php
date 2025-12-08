<?php
/**
 * Read User Addresses Endpoint
 * GET /api/addresses/read.php?user_id={id}
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Address.php';

$database = new Database();
$db = $database->getConnection();

$address = new Address($db);

// Get user_id from query parameter
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ($user_id) {
    $address->UserID = $user_id;
    $stmt = $address->getUserAddresses();
    $num = $stmt->rowCount();

    if ($num > 0) {
        $addresses_arr = array();

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);

            $address_item = array(
                "address_id" => $AddressID,
                "address_type" => $AddressType,
                "address_line" => $AddressLine,
                "latitude" => $Latitude,
                "longitude" => $Longitude,
                "created_at" => $CreatedAt
            );

            array_push($addresses_arr, $address_item);
        }

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Addresses retrieved successfully",
            "data" => $addresses_arr
        ]);
    } else {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "No addresses found",
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
