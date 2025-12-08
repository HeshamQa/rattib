<?php
/**
 * Read User Badges Endpoint
 * GET /api/badges/user_badges.php?user_id={id}
 * Returns badges earned by a specific user
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if (!$user_id) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "User ID is required"
    ]);
    exit;
}

try {
    $query = "SELECT b.BadgeID, b.BadgeName, b.Description, b.IconURL, b.Criteria, ub.EarnedAt
              FROM Badge b
              INNER JOIN UserBadges ub ON b.BadgeID = ub.BadgeID
              WHERE ub.UserID = :user_id
              ORDER BY ub.EarnedAt DESC";

    $stmt = $db->prepare($query);
    $stmt->bindParam(":user_id", $user_id);
    $stmt->execute();

    $badges_arr = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $badge_item = array(
            "badge_id" => $row['BadgeID'],
            "badge_name" => $row['BadgeName'],
            "description" => $row['Description'],
            "icon_url" => $row['IconURL'],
            "criteria" => $row['Criteria'],
            "earned_at" => $row['EarnedAt']
        );

        array_push($badges_arr, $badge_item);
    }

    http_response_code(200);
    echo json_encode([
        "success" => true,
        "message" => "User badges retrieved successfully",
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
