<?php
/**
 * Delete Task Endpoint
 * DELETE /api/tasks/delete.php?id={id}&user_id={user_id}
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE, GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Task.php';

$database = new Database();
$db = $database->getConnection();

$task = new Task($db);

// Get ID from query parameter
$task_id = isset($_GET['id']) ? $_GET['id'] : null;
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ($task_id && $user_id) {
    $task->TaskID = $task_id;
    $task->UserID = $user_id;

    if ($task->delete()) {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Task deleted successfully"
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to delete task"
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Task ID and User ID are required"
    ]);
}
?>
