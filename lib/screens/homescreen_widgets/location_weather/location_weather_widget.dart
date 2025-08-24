import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationWeatherWidget extends StatefulWidget {
  const LocationWeatherWidget({super.key});

  @override
  State<LocationWeatherWidget> createState() => _LocationWeatherWidgetState();
}

class _LocationWeatherWidgetState extends State<LocationWeatherWidget> {
  late Future<String> imageUrl;
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    imageUrl = _retrieveImageUrl();
    weatherData = _fetchWeatherData();
  }

  Future<String> _retrieveImageUrl() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot documentSnapshot = await firestore
        .collection('data')
        .doc('location')
        .get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      return data['mapImageUrl'] as String;
    }
    return "";
  }

  Future<Map<String, dynamic>> _fetchWeatherData() async {
    String baseUrl =
        "http://api.weatherapi.com/v1/current.json?key=7945c7657be84b9fa00102127252408&q=Chennai&aqi=no";
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"error": "Failed to fetch weather data"};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, // 2x the width of individual squares
      height: 280, // Same height as individual squares
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        ),
      ),
      child: Row(
        children: [
          // Left half - Location Square
          Expanded(child: _buildLocationSquare()),
          // Right half - Weather Square
          Expanded(child: _buildWeatherSquare()),
        ],
      ),
    );
  }

  Widget _buildLocationSquare() {
    return FutureBuilder(
      future: imageUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading location',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.1),
          ),
          child: const Center(
            child: Icon(Icons.location_on, color: Colors.white, size: 48),
          ),
        );
      },
    );
  }

  Widget _buildWeatherSquare() {
    return FutureBuilder(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading weather',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!["error"] == null) {
          final data = snapshot.data!;
          final location = data["location"];
          final current = data["current"];
          final condition = current["condition"];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with location and weather icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location name with arrow
                    Text(
                      location["name"] ?? "Unknown",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Weather icon
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getWeatherIcon(condition["code"] ?? 1000),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Main temperature
                Text(
                  "${(current["temp_c"] ?? 0).round()}°C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // Feels like temperature
                Text(
                  "Feels like ${(current["feelslike_c"] ?? 0).round()}°",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Weather condition text
                Text(
                  condition["text"] ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                // Detailed weather information (compact)
                _buildWeatherDetail(
                  "Precip",
                  "${(current["precip_mm"] ?? 0).round()}%",
                ),
                _buildWeatherDetail("Humidity", "${current["humidity"] ?? 0}%"),
              ],
            ),
          );
        }

        return const Center(
          child: Text(
            'No weather data',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      },
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(int code) {
    // Weather condition codes mapping
    switch (code) {
      case 1000: // Clear
        return Icons.wb_sunny;
      case 1003: // Partly cloudy
        return Icons.cloud;
      case 1006: // Cloudy
        return Icons.cloud;
      case 1009: // Overcast
        return Icons.cloud;
      case 1030: // Mist
        return Icons.cloud;
      case 1063: // Patchy rain
      case 1066: // Patchy snow
      case 1069: // Patchy sleet
        return Icons.grain;
      case 1087: // Thundery outbreaks
        return Icons.thunderstorm;
      case 1114: // Blowing snow
      case 1117: // Blizzard
        return Icons.ac_unit;
      case 1135: // Fog
      case 1147: // Freezing fog
        return Icons.cloud;
      case 1150: // Patchy light drizzle
      case 1153: // Light drizzle
      case 1168: // Freezing drizzle
        return Icons.grain;
      case 1180: // Patchy light rain
      case 1183: // Light rain
      case 1186: // Moderate rain
      case 1189: // Heavy rain
        return Icons.grain;
      case 1192: // Very heavy rain
      case 1195: // Extreme rain
        return Icons.grain;
      case 1201: // Moderate or heavy freezing rain
      case 1204: // Light sleet
      case 1207: // Moderate or heavy sleet
        return Icons.grain;
      case 1210: // Patchy light snow
      case 1213: // Light snow
      case 1216: // Patchy moderate snow
      case 1219: // Moderate snow
      case 1222: // Patchy heavy snow
      case 1225: // Heavy snow
        return Icons.ac_unit;
      case 1237: // Ice pellets
        return Icons.ac_unit;
      case 1240: // Light rain shower
      case 1243: // Moderate or heavy rain shower
        return Icons.grain;
      case 1246: // Torrential rain shower
        return Icons.grain;
      case 1249: // Light sleet showers
      case 1252: // Moderate or heavy sleet showers
        return Icons.grain;
      case 1255: // Light snow showers
      case 1258: // Moderate or heavy snow showers
        return Icons.ac_unit;
      case 1261: // Light showers of ice pellets
      case 1264: // Moderate or heavy showers of ice pellets
        return Icons.ac_unit;
      case 1273: // Patchy light rain with thunder
      case 1276: // Moderate or heavy rain with thunder
        return Icons.thunderstorm;
      case 1279: // Patchy light snow with thunder
      case 1282: // Moderate or heavy snow with thunder
        return Icons.thunderstorm;
      default:
        return Icons.cloud;
    }
  }
}
