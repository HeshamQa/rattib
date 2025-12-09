<?php
/**
 * Optimize Trip Route Endpoint
 * POST /api/trips/optimize_route.php
 * 
 * This endpoint optimizes the order of trips based on their locations
 * using a nearest neighbor algorithm (Greedy TSP approximation)
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';
include_once '../../models/Trip.php';

$database = new Database();
$db = $database->getConnection();

$trip = new Trip($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Validate required fields
if (!empty($data->user_id)) {
    $trip->UserID = $data->user_id;
    $stmt = $trip->getUserTrips();
    $num = $stmt->rowCount();

    if ($num > 0) {
        $trips = array();

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            // Only include trips with status 'Planned'
            if ($row['Status'] === 'Planned') {
                $trips[] = array(
                    "trip_id" => $row['TripID'],
                    "destination" => $row['Destination'],
                    "destination_latitude" => floatval($row['DestinationLatitude']),
                    "destination_longitude" => floatval($row['DestinationLongitude']),
                    "pickup_location" => $row['PickupLocation'],
                    "pickup_latitude" => floatval($row['PickupLatitude']),
                    "pickup_longitude" => floatval($row['PickupLongitude']),
                    "trip_date" => $row['TripDate'],
                    "status" => $row['Status'],
                    "created_at" => $row['CreatedAt']
                );
            }
        }

        if (count($trips) === 0) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "No planned trips to optimize",
                "data" => []
            ]);
            exit;
        }

        // Optimize route using nearest neighbor algorithm
        $optimizedTrips = optimizeRoute($trips);

        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Route optimized successfully",
            "data" => $optimizedTrips
        ]);
    } else {
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "No trips found",
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

/**
 * Calculate distance between two points using Haversine formula
 * Returns distance in kilometers
 */
function calculateDistance($lat1, $lon1, $lat2, $lon2)
{
    $earthRadius = 6371; // Earth's radius in kilometers

    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);

    $a = sin($dLat / 2) * sin($dLat / 2) +
        cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
        sin($dLon / 2) * sin($dLon / 2);

    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

    return $earthRadius * $c;
}

/**
 * Optimize route using Nearest Neighbor algorithm
 * This is a greedy approximation of the Traveling Salesman Problem
 */
function optimizeRoute($trips)
{
    if (count($trips) <= 1) {
        return $trips;
    }

    $optimized = array();
    $remaining = $trips;

    // Start with the first trip (could be improved by finding the best starting point)
    $current = array_shift($remaining);
    $optimized[] = $current;

    // Current position is the destination of the last trip
    $currentLat = $current['destination_latitude'];
    $currentLon = $current['destination_longitude'];

    // Keep finding the nearest next trip
    while (count($remaining) > 0) {
        $nearestIndex = 0;
        $minDistance = PHP_FLOAT_MAX;

        // Find the nearest trip's pickup location
        for ($i = 0; $i < count($remaining); $i++) {
            $distance = calculateDistance(
                $currentLat,
                $currentLon,
                $remaining[$i]['pickup_latitude'],
                $remaining[$i]['pickup_longitude']
            );

            if ($distance < $minDistance) {
                $minDistance = $distance;
                $nearestIndex = $i;
            }
        }

        // Add the nearest trip to optimized route
        $nextTrip = $remaining[$nearestIndex];
        $optimized[] = $nextTrip;

        // Update current position to the destination of this trip
        $currentLat = $nextTrip['destination_latitude'];
        $currentLon = $nextTrip['destination_longitude'];

        // Remove from remaining
        array_splice($remaining, $nearestIndex, 1);
    }

    // Add order index to each trip
    for ($i = 0; $i < count($optimized); $i++) {
        $optimized[$i]['order'] = $i + 1;
    }

    return $optimized;
}
?>