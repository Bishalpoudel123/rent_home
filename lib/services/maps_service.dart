  class MapsService {
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    await Future.delayed(Duration(milliseconds: 500));
    return "123 Main Street, City, State 12345";
  }
  
  Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    await Future.delayed(Duration(milliseconds: 500));
    return {
      'latitude': 40.7128,
      'longitude': -74.0060,
    };
  }
  
  Future<double> calculateDistance(double lat1, double lng1, double lat2, double lng2) async {
    await Future.delayed(Duration(milliseconds: 100));
    return 5.2; // Distance in kilometers
  }
}