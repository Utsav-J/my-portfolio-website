import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class WeatherSquare extends StatefulWidget {
  const WeatherSquare({super.key});

  @override
  State<WeatherSquare> createState() => _WeatherSquareState();
}

class _WeatherSquareState extends State<WeatherSquare> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = _fetchWeatherData();
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
    return FutureBuilder(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 200.w,
            height: 280.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: 200.w,
            height: 280.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              ),
            ),
            child: Center(
              child: Text(
                'Error loading weather',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!["error"] == null) {
          final data = snapshot.data!;
          final location = data["location"];
          final current = data["current"];
          final condition = current["condition"];

          return Container(
            width: 200.w,
            height: 280.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with location and weather icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location name with arrow
                      Row(
                        children: [
                          Text(
                            location["name"] ?? "Unknown",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ],
                      ),
                      // Weather icon and high/low temps
                      Column(
                        children: [
                          // Weather condition icon
                          Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getWeatherIcon(condition["code"] ?? 1000),
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          // High and low temperatures (using current temp as placeholder)
                          Text(
                            "H:${(current["temp_c"] ?? 0).round()}°",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "L:${(current["temp_c"] ?? 0).round()}°",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Main temperature
                  Text(
                    "${(current["temp_c"] ?? 0).round()}°",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Feels like temperature
                  Text(
                    "Feels like ${(current["feelslike_c"] ?? 0).round()}°",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Weather condition text
                  Text(
                    condition["text"] ?? "Unknown",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  // Detailed weather information
                  _buildWeatherDetail(
                    "Precip",
                    "${(current["precip_mm"] ?? 0).round()}%",
                  ),
                  _buildWeatherDetail(
                    "Humidity",
                    "${(current["humidity"] ?? 0)}%",
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          width: 200.w,
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
          ),
          child: Center(
            child: Text(
              'No weather data',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
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
