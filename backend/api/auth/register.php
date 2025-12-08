<?php
/**
 * User Registration Endpoint
 * POST /api/auth/register.php
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
    !empty($data->name) &&
    !empty($data->email) &&
    !empty($data->password)
) {
    // Set user properties
    $user->Name = $data->name;
    $user->Email = $data->email;
    $user->Password = $data->password;

    // Check if email already exists
    if ($user->emailExists()) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Email already exists. Please use a different email."
        ]);
        exit;
    }

    // Create user
    if ($user->create()) {
        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "Account created successfully!",
            "data" => [
                "user_id" => $user->UserID,
                "name" => $user->Name,
                "email" => $user->Email
            ]
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to create account. Please try again."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Unable to create account. All fields are required."
    ]);
}
?>
