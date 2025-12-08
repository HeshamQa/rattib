<?php
/**
 * User Logout Endpoint
 * POST /api/auth/logout.php
 *
 * Note: Since we're using stateless authentication (no sessions on backend),
 * the actual logout logic happens on the client side by clearing stored tokens/user data.
 * This endpoint is provided for consistency and can be extended if needed.
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

http_response_code(200);
echo json_encode([
    "success" => true,
    "message" => "Logout successful!"
]);
?>
