class AppConfig {
  static const String apiBaseUrl = 'http://localhost:3000/api';
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/users/profile';
  static const String trainersEndpoint = '/trainers';
  static const String classesEndpoint = '/classes';
  static const String workoutsEndpoint = '/workouts';
}
