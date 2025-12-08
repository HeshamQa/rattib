<?php
/**
 * Create Task Endpoint
 * POST /api/tasks/create.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Task.php';

$database = new Database();
$db = $database->getConnection();

$task = new Task($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Validate required fields
if (
    !empty($data->user_id) &&
    !empty($data->title)
) {
    // Set task properties
    $task->UserID = $data->user_id;
    $task->Title = $data->title;
    $task->Description = isset($data->description) ? $data->description : '';
    $task->DueDate = isset($data->due_date) ? $data->due_date : null;
    $task->Location = isset($data->location) ? $data->location : '';
    $task->Latitude = isset($data->latitude) ? $data->latitude : null;
    $task->Longitude = isset($data->longitude) ? $data->longitude : null;
    $task->Status = isset($data->status) ? $data->status : 'Pending';

    // Create task
    if ($task->create()) {
        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "Task created successfully!",
            "data" => [
                "task_id" => $task->TaskID,
                "title" => $task->Title,
                "description" => $task->Description,
                "due_date" => $task->DueDate,
                "location" => $task->Location,
                "status" => $task->Status
            ]
        ]);
    } else {
        http_response_code(503);
        echo json_encode([
            "success" => false,
            "message" => "Unable to create task. Please try again."
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Unable to create task. Title is required."
    ]);
}
?>
