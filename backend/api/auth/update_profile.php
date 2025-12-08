<?php
/**
 * Update User Profile Endpoint
 * POST /api/auth/update_profile.php
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
    !empty($data->user_id) &&
    !empty($data->name) &&
    !empty($data->email)
) {
    // Set user properties
    $user->UserID = $data->user_id;
    $user->Name = $data->name;
    $user->Email = $data->email;

    // Check if email is being changed and if it already exists
    $currentUser = new User($db);
    $currentUser->UserID = $data->user_id;
    if ($currentUser->getById()) {
        // If email is being changed, check if new email exists
        if ($currentUser->Email !== $data->email) {
            $emailCheck = new User($db);
            $emailCheck->Email = $data->email;
            if ($emailCheck->emailExists()) {
                http_response_code(409);
                echo json_encode([
                    "success" => false,
                    "message" => "Email already exists. Please use a different email."
                ]);
                exit();
            }
        }
    }

    // Attempt to update profile
    if ($user->update()) {
        // Fetch updated user data
        if ($user->getById()) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "Profile updated successfully!",
                "data" => [
                    "user_id" => $user->UserID,
                    "name" => $user->Name,
                    "email" => $user->Email
                ]
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Profile updated but failed to retrieve updated data."
            ]);
        }
    } else {
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Failed to update profile. Please try again."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "User ID, name, and email are required."
    ]);
}
?>
