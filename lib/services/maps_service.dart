import 'package:url_launcher/url_launcher.dart';

class MapsService {
  /// Google Maps app deep link — FREE, no API key needed
  /// Opens the Google Maps app already installed on user's phone
  static Future<void> openDirections({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    // Deep link to Google Maps app
    final googleMapsUrl =
        'google.navigation:q=$latitude,$longitude&mode=d';
    final googleMapsWebUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

    final appUri = Uri.parse(googleMapsUrl);
    final webUri = Uri.parse(googleMapsWebUrl);

    if (await canLaunchUrl(appUri)) {
      // Opens Google Maps app directly
      await launchUrl(appUri);
    } else {
      // Fallback to browser if app not installed
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Open Google Maps to show a location pin
  static Future<void> showLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final encodedLabel = Uri.encodeComponent(label ?? 'कोठा');
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$encodedLabel';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Calculate approximate distance between two points (km)
  static double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const double earthRadius = 6371;
    final double dLat = _toRad(lat2 - lat1);
    final double dLon = _toRad(lon2 - lon1);
    final double a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRad(lat1)) * _cos(_toRad(lat2)) *
            _sin(dLon / 2) * _sin(dLon / 2);
    final double c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRad(double deg) => deg * 3.141592653589793 / 180;
  static double _sin(double x) => x - x * x * x / 6;
  static double _cos(double x) => 1 - x * x / 2;
  static double _atan2(double y, double x) => y / (x == 0 ? 0.0001 : x);
  static double _sqrt(double x) => x <= 0 ? 0 : x * (1 - (x - 1) / 2);
}