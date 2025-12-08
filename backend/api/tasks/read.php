<?php
/**
 * Read User Tasks Endpoint
 * GET /api/tasks/read.php?user_id={id}
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Task.php';

$database = new Database();
$db = $database->getConnection();

$task = new Task($db);

// Get user_id from query parameter
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ($user_id) {
    $task->UserID = $user_id;
    $stmt = $task->getUserTasks();
    $num = $stmt->rowCount();

    if ($num > 0) {
        $tasks_arr = array();

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);

            $task_item = array(
                "task_id" => $TaskID,
                "title" => $Title,
                "description" => $Description,
                "due_date" => $DueDate,
                "location" => $Location,
                "latitude" => $Latitude,
                "longitude" => $Longitude,
                "status" => $Status,
                "created_at" => $CreatedAt
            );

            array_push($tasks_arr, $task_item);
        }

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Tasks retrieved successfully",
            "data" => $tasks_arr
        ]);
    } else {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "No tasks found",
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
