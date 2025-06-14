import 'package:flutter/material.dart';

enum WidgetType {
  weather,
  sensorData,
  chart,
  status,
  quickAction,
}

class DashboardWidget extends StatelessWidget {
  final String id;
  final String title;
  final WidgetType type;
  final Widget child;
  final bool isDraggable;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool isEditing;

  const DashboardWidget({
    Key? key,
    required this.id,
    required this.title,
    required this.type,
    required this.child,
    this.isDraggable = true,
    this.onTap,
    this.onRemove,
    this.isEditing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isEditing ? 8 : 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isEditing 
            ? Border.all(color: Theme.of(context).primaryColor, width: 2)
            : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isEditing && onRemove != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onRemove,
                      tooltip: 'Remove widget',
                    ),
                ],
              ),
            ),
            // Widget content
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Weather Widget
class WeatherWidget extends StatelessWidget {
  final String temperature;
  final String condition;
  final String humidity;
  final String wind;
  final VoidCallback? onTap;

  const WeatherWidget({
    Key? key,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.wind,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardWidget(
      id: 'weather',
      title: 'Weather',
      type: WidgetType.weather,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                temperature,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Icon(
                _getWeatherIcon(condition),
                size: 48,
                color: _getWeatherColor(condition),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            condition,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(context, 'Humidity', humidity, Icons.water_drop),
              _buildWeatherDetail(context, 'Wind', wind, Icons.air),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sun') || lower.contains('clear')) return Icons.wb_sunny;
    if (lower.contains('cloud')) return Icons.cloud;
    if (lower.contains('rain')) return Icons.thunderstorm;
    if (lower.contains('snow')) return Icons.ac_unit;
    return Icons.wb_sunny;
  }

  Color _getWeatherColor(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sun') || lower.contains('clear')) return Colors.orange;
    if (lower.contains('cloud')) return Colors.blueGrey;
    if (lower.contains('rain')) return Colors.blue;
    if (lower.contains('snow')) return Colors.indigo;
    return Colors.orange;
  }
}

// Sensor Data Widget
class SensorDataWidget extends StatelessWidget {
  final int temperature;
  final int humidity;
  final int soilMoisture;
  final VoidCallback? onTap;

  const SensorDataWidget({
    Key? key,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardWidget(
      id: 'sensor_data',
      title: 'Sensor Data',
      type: WidgetType.sensorData,
      onTap: onTap,
      child: Column(
        children: [
          _buildSensorRow(context, 'Temperature', '$temperature°C', Icons.thermostat, Colors.red),
          const SizedBox(height: 12),
          _buildSensorRow(context, 'Humidity', '$humidity%', Icons.water_drop, Colors.blue),
          const SizedBox(height: 12),
          _buildSensorRow(context, 'Soil Moisture', '$soilMoisture%', Icons.grass, Colors.brown),
        ],
      ),
    );
  }

  Widget _buildSensorRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
} 