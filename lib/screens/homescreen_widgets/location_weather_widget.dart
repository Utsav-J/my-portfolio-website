import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portfolio/utils/firebase_utils.dart';

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
    return await FirebaseUtils.getLocationImageUrl();
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
      width: double.infinity, // Use available width
      height: double.infinity, // Use available height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
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
          return Center(
            child: Text(
              'Error loading location',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            margin: EdgeInsets.all(8.0.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 48.sp,
                    ),
                  );
                },
              ),
            ),
          );
        }
        return Container(
          margin: EdgeInsets.all(8.0.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Icon(Icons.location_on, color: Colors.white, size: 48.sp),
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
          return Center(
            child: Text(
              'Error loading weather',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!["error"] == null) {
          final data = snapshot.data!;
          final location = data["location"];
          final current = data["current"];
          final condition = current["condition"];

          return Padding(
            padding: EdgeInsets.all(8.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Weather icon
                      Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          _getWeatherIcon(condition["code"] ?? 1000),
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Main temperature
                  Text(
                    "${(current["temp_c"] ?? 0).round()}°C",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  _buildWeatherDetailGrid(current),
                ],
              ),
            ),
          );
        }

        return Center(
          child: Text(
            'No weather data',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        );
      },
    );
  }

  Widget _buildWeatherDetailGrid(dynamic current) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  current["condition"]["text"] ?? "Unknown",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _buildWeatherDetailRow(
                  Icons.thermostat,
                  "Real Feel",
                  current["feelslike_c"],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: _buildWeatherDetailRow(
                  Icons.water_drop,
                  "Humidity",
                  current["humidity"],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _buildWeatherDetailRow(
                  CupertinoIcons.cloud_rain_fill,
                  "Precipitation",
                  current["precip_mm"],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDetailRow(IconData icon, String title, dynamic value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 12.sp),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          "${(value ?? 0).round()}${title == "Humidity"
              ? "%"
              : title == "Precipitation"
              ? "mm"
              : "°C"}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
