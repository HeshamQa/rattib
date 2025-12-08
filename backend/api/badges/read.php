<?php
/**
 * Read Badges Endpoint
 * GET /api/badges/read.php
 * Returns all available badges
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $query = "SELECT BadgeID, BadgeName, Description, IconURL, Criteria
              FROM Badge
              ORDER BY BadgeID ASC";

    $stmt = $db->prepare($query);
    $stmt->execute();

    $badges_arr = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $badge_item = array(
            "badge_id" => $row['BadgeID'],
            "badge_name" => $row['BadgeName'],
            "description" => $row['Description'],
            "icon_url" => $row['IconURL'],
            "criteria" => $row['Criteria']
        );

        array_push($badges_arr, $badge_item);
    }

    http_response_code(200);
    echo json_encode([
        "success" => true,
        "message" => "Badges retrieved successfully",
        "data" => $badges_arr
    ]);
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Error: " . $e->getMessage()
    ]);
}
?>
