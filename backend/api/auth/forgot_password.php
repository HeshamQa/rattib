<?php
/**
 * Forgot Password Endpoint
 * POST /api/auth/forgot_password.php
 *
 * Note: This is a placeholder implementation.
 * In production, this should:
 * 1. Generate a password reset token
 * 2. Send email with reset link
 * 3. Store token with expiration
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

// Validate email
if (!empty($data->email)) {
    $user->Email = $data->email;

    // Check if email exists
    if ($user->emailExists()) {
        // TODO: In production, generate token and send email
        // For now, just return success
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "If an account with this email exists, a password reset link has been sent."
        ]);
    } else {
        // Return success even if email doesn't exist (security best practice)
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "If an account with this email exists, a password reset link has been sent."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Email is required."
    ]);
}
?>
