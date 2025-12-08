<?php
/**
 * User Login Endpoint
 * POST /api/auth/login.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/User.php';

$database = new Database();
$db = $database->getConnection();

$user = new User($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Validate required fields
if (
    !empty($data->email) &&
    !empty($data->password)
) {
    // Set user properties
    $user->Email = $data->email;
    $user->Password = $data->password;

    // Attempt login
    if ($user->login()) {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Login successful!",
            "data" => [
                "user_id" => $user->UserID,
                "name" => $user->Name,
                "email" => $user->Email
            ]
        ]);
    } else {
        http_response_code(401);
        echo json_encode([
            "success" => false,
            "message" => "Login failed. Please check your credentials."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Email and password are required."
    ]);
}
?>
