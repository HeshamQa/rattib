/// API Constants
/// Contains all API endpoints and configuration
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://ratip.online/rattibapis';

  // API Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Authentication Endpoints
  static const String loginEndpoint = '/api/auth/login.php';
  static const String registerEndpoint = '/api/auth/register.php';
  static const String logoutEndpoint = '/api/auth/logout.php';
  static const String forgotPasswordEndpoint = '/api/auth/forgot_password.php';
  static const String updateProfileEndpoint = '/api/auth/update_profile.php';

  // Tasks Endpoints
  static const String tasksReadEndpoint = '/api/tasks/read.php';
  static const String tasksCreateEndpoint = '/api/tasks/create.php';
  static const String tasksUpdateEndpoint = '/api/tasks/update.php';
  static const String tasksDeleteEndpoint = '/api/tasks/delete.php';

  // Trips Endpoints
  static const String tripsReadEndpoint = '/api/trips/read.php';
  static const String tripsCreateEndpoint = '/api/trips/create.php';
  static const String tripsUpdateEndpoint = '/api/trips/update.php';
  static const String tripsDeleteEndpoint = '/api/trips/delete.php';
  static const String tripsOptimizeRouteEndpoint =
      '/api/trips/optimize_route.php';

  // Addresses Endpoints
  static const String addressesReadEndpoint = '/api/addresses/read.php';
  static const String addressesCreateEndpoint = '/api/addresses/create.php';
  static const String addressesDeleteEndpoint = '/api/addresses/delete.php';

  // Badges Endpoints
  static const String badgesReadEndpoint = '/api/badges/read.php';
  static const String userBadgesEndpoint = '/api/badges/user_badges.php';

  // Inquiry Endpoints
  static const String inquiryCreateEndpoint = '/api/inquiry/create.php';
  static const String inquiryReadEndpoint = '/api/inquiry/read.php';

  // Google Maps API Key (Placeholder - to be updated by user)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

  // SOS Endpoints
  static const String sosCreateEndpoint = '/api/sos/create.php';
  static const String sosReadEndpoint   = '/api/sos/read.php';
  static const String sosUpdateEndpoint = '/api/sos/update.php';
  static const String sosDeleteEndpoint = '/api/sos/delete.php';

  // Admin Endpoints
  static const String adminLoginEndpoint = '/api/admin/login.php';
  static const String adminCreateEndpoint = '/api/admin/create.php';
  static const String adminStatsEndpoint = '/api/admin/stats.php';
  static const String adminUsersEndpoint = '/api/admin/users.php';
  static const String adminDeleteUserEndpoint = '/api/admin/delete_user.php';
  static const String adminTasksEndpoint = '/api/admin/tasks.php';
  static const String adminTripsEndpoint = '/api/admin/trips.php';
  static const String adminInquiriesEndpoint = '/api/admin/inquiries.php';
  static const String adminRespondInquiryEndpoint = '/api/admin/respond_inquiry.php';
}
