import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'dart:async';

// ENSURE THIS IS THE CORRECT AND ONLY PATH for SensorDataProvider and SensorData model
import '../plant_data_provider.dart'; // This file MUST define SensorData and SensorDataProvider

// --- AppColors and AppTextStyles (largely unchanged, good foundation) ---
class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color accent = Color(0xFFFF9800);
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color chartGridColor = Color(0xFFE0E0E0);

  static const Color temperature = Colors.redAccent;
  static const Color humidity = Colors.blueAccent;
  static const Color soilMoisture = Color(0xFF6D4C41);

  static const Color soilMoistureCritical = Color(0xFFD32F2F);
  static const Color soilMoistureDry = Color(0xFFFF9800);
  static const Color soilMoistureWet = Color(0xFF1976D2);
  static const Color optimalRangeBackground = Color(0xFFE8F5E9);

  static const Color optimalTemperatureRange = Color(0xFFFFF3E0);
  static const Color optimalHumidityRange = Color(0xFFE3F2FD);
}

class AppTextStyles {
  static TextStyle display(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          );

  static TextStyle headline(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          );

  static TextStyle title(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary, // Consider AppColors.primary for main titles
          );

  static TextStyle body(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.4, // Added for better readability
          );
          
  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.4, // Added for better readability
          );

  static TextStyle caption(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.textSecondary.withOpacity(0.9),
            fontSize: 12,
          );
  
  static TextStyle chartAxis(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.textSecondary.withOpacity(0.8),
            fontSize: 10,
          );
}
// --- End Theme Definitions ---

class SensorDetailsPage extends StatefulWidget {
  final SensorData sensorData;
  final SensorDataProvider sensorProvider;

  const SensorDetailsPage({
    Key? key,
    required this.sensorData,
    required this.sensorProvider,
  }) : super(key: key);

  @override
  State<SensorDetailsPage> createState() => _SensorDetailsPageState();
}

class _SensorDetailsPageState extends State<SensorDetailsPage> {
  Timer? _refreshTimer;
  List<FlSpot> _tempSpots = [];
  List<FlSpot> _humiditySpots = [];
  DateTime _lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateChartData();
    // Change refresh interval to 5 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _refreshData();
    });
  }

  void _updateChartData() {
    setState(() {
      // Only use actual sensor data for the charts
      _tempSpots = widget.sensorData.temperatureHistory
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
          .toList();
      
      _humiditySpots = widget.sensorData.humidityHistory
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
          .toList();
    });
  }

  Future<void> _refreshData() async {
    await widget.sensorProvider.fetchSensorData();
    if (mounted) {
      setState(() {
        _lastUpdate = DateTime.now();
        _updateChartData();
      });
    }
  }

  // --- Chart Helper Functions (assumed to be well-implemented) ---
  // _generateSpotsForChart, _generateSparklineSpots, _leftTitleWidgets, 
  // _bottomTitleWidgets, _getSoilMoistureBarColor, _makeBarGroupData,
  // _calculateAverageMoistureForDisplay remain structurally the same.
  // For brevity, their implementation is omitted here but assumed to be from your provided code.

  Widget _leftTitleWidgets(BuildContext context, double value, TitleMeta meta, String unit, {Color? textColor}) {
    final style = AppTextStyles.chartAxis(context).copyWith(color: textColor ?? AppTextStyles.chartAxis(context).color);
    bool isAtMin = (value - meta.min).abs() < 0.01;
    bool isAtMax = (value - meta.max).abs() < 0.01;
    bool isAtInterval = meta.appliedInterval > 0.1 && ((value - meta.min) % meta.appliedInterval).abs() < 0.01;

    if (isAtMin || isAtMax || (isAtInterval && value > meta.min && value < meta.max)) {
        return Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Text('${value.toInt()}$unit', style: style, textAlign: TextAlign.right),
        );
    }
    return const SizedBox.shrink();
  }

  Widget _bottomTitleWidgets(BuildContext context, double value, TitleMeta meta, {required int totalSpots, Color? textColor}) {
    final style = AppTextStyles.chartAxis(context).copyWith(color: textColor ?? AppTextStyles.chartAxis(context).color);
    String text = '';
    final int spotIndex = value.toInt();

    if (totalSpots == 0) return const SizedBox.shrink(); 
    if (totalSpots == 1 && spotIndex == 0) {
        text = 'Current';
    } else if (totalSpots > 1) {
      if (spotIndex == 0) text = 'Start';
      else if (spotIndex == totalSpots - 1) text = 'End';
      else if (totalSpots >= 5 && spotIndex == (totalSpots / 2).floor()) {
          text = 'Mid';
      }
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 8.0, child: Text(text, style: style));
  }

  Color _getSoilMoistureBarColor(double value) {
    const double criticalDry = 15.0;
    const double optimalMin = 30.0;
    const double optimalMax = 70.0;
    const double criticalWet = 85.0;

    if (value < criticalDry) return AppColors.soilMoistureCritical;
    if (value < optimalMin) return AppColors.soilMoistureDry;
    if (value <= optimalMax) return AppColors.soilMoisture;
    if (value <= criticalWet) return AppColors.soilMoistureWet;
    return AppColors.soilMoistureCritical;
  }

  BarChartGroupData _makeBarGroupData(BuildContext context, int x, double y) {
    const double criticalDry = 15.0;
    const double criticalWet = 85.0;
    Color barColor = _getSoilMoistureBarColor(y);

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 22,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          borderSide: y < criticalDry || y > criticalWet
              ? BorderSide(color: AppColors.textPrimary.withOpacity(0.6), width: 1)
              : BorderSide.none,
        ),
      ],
    );
  }

  String _calculateAverageMoistureForDisplay(SensorData data) {
    final values = [data.soilMoisture1, data.soilMoisture2, data.soilMoisture3, data.soilMoisture4];
    if (values.isEmpty) return 'Avg: N/A';
    double sum = values.fold(0.0, (prev, element) => prev + element);
    double avg = sum / values.length;
    return 'Avg: ${avg.toStringAsFixed(1)}%';
  }

  String _getTemperatureStatus(double temp) {
    if (temp < 15) return 'Too Cold';
    if (temp < 18) return 'Cool';
    if (temp <= 25) return 'Optimal';
    if (temp <= 28) return 'Warm';
    return 'Too Hot';
  }

  @override
  Widget build(BuildContext context) {
    // Use the actual sensor data instead
    final sensorData = widget.sensorData;
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sensor Details', 
              style: AppTextStyles.title(context).copyWith(color: AppColors.primary)
            ),
            Text(
              'Last Update: ${_lastUpdate.hour.toString().padLeft(2, '0')}:${_lastUpdate.minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        backgroundColor: AppColors.cardBackground,
        elevation: 2,
        iconTheme: IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.primary.withOpacity(0.8)),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          )
        ],
      ),
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             _ChartCard(
  title: 'Temperature',
  currentValue: '${sensorData.temperature}°C',
  icon: Icons.thermostat_outlined,
  iconColor: AppColors.temperature,
  chart: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${sensorData.temperature}°C',
        style: AppTextStyles.display(context).copyWith(
          color: AppColors.temperature,
          fontSize: 40,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        _getTemperatureStatus(sensorData.temperature.toDouble()),
        style: AppTextStyles.bodyLarge(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 45,
            lineBarsData: [
              LineChartBarData(
                spots: _tempSpots,
                isCurved: true,
                curveSmoothness: 0.25,
                barWidth: 3.5,
                color: AppColors.temperature,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.temperature.withOpacity(0.4),
                      AppColors.temperature.withOpacity(0.05),
                    ],
                  ),
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    final isLast = index == _tempSpots.length - 1;
                    return FlDotCirclePainter(
                      radius: isLast ? 6 : 0,
                      color: AppColors.temperature,
                      strokeWidth: isLast ? 2.5 : 0,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 10,
                  getTitlesWidget: (val, meta) => _leftTitleWidgets(
                    context,
                    val,
                    meta,
                    '°C',
                    textColor: AppColors.temperature.withOpacity(0.7),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: _tempSpots.length > 1,
                  reservedSize: 30,
                  interval: (_tempSpots.length > 1)
                      ? ((_tempSpots.length - 1) /
                              (_tempSpots.length > 4
                                  ? 3
                                  : (_tempSpots.length - 1)))
                          .ceilToDouble()
                          .clamp(1.0, double.infinity)
                      : 1,
                  getTitlesWidget: (val, meta) => _bottomTitleWidgets(
                    context,
                    val,
                    meta,
                    totalSpots: _tempSpots.length,
                    textColor: AppColors.temperature.withOpacity(0.7),
                  ),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 10,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.chartGridColor.withOpacity(0.3),
                strokeWidth: 0.8,
              ),
            ),
            rangeAnnotations: RangeAnnotations(
              horizontalRangeAnnotations: [
                HorizontalRangeAnnotation(
                  y1: 18.0,
                  y2: 25.0,
                  color: AppColors.optimalTemperatureRange.withOpacity(0.6),
                ),
              ],
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppColors.temperature.withOpacity(0.85),
                tooltipRoundedRadius: 8,
                tooltipPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)}°C',
                    AppTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: AppColors.temperature.withOpacity(0.9),
                      strokeWidth: 2,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 6,
                        color: AppColors.temperature,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubicEmphasized,
        ),
      ),
    ],
  ),
),

              const SizedBox(height: 20),
              _ChartCard(
                title: 'Humidity',
                currentValue: '${sensorData.humidity}%',
                icon: Icons.water_drop_outlined,
                iconColor: AppColors.humidity,
                chart: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sensorData.humidity}%',
                      style: AppTextStyles.display(context).copyWith(
                        color: AppColors.humidity,
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sensorData.humidity < 30 ? "Very Dry" :
                      sensorData.humidity < 40 ? "Dry" :
                      sensorData.humidity <= 60 ? "Optimal" :
                      sensorData.humidity <= 70 ? "Humid" : "Very Humid",
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _humiditySpots,
                              isCurved: true,
                              barWidth: 3,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.humidity,
                                  AppColors.humidity.withOpacity(0.7),
                                ],
                                stops: const [0.4, 1.0],
                              ),
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                checkToShowDot: (spot, barData) => 
                                  spot.x == 0 || spot.x == _humiditySpots.length - 1,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: AppColors.humidity,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.humidity.withOpacity(0.25),
                                    AppColors.humidity.withOpacity(0.0),
                                  ],
                                  stops: const [0.2, 0.9],
                                ),
                              ),
                            ),
                          ],
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 25,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: AppColors.chartGridColor.withOpacity(0.15),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                          ),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          minY: 0,
                          maxY: 100,
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: AppColors.humidity.withOpacity(0.8),
                              tooltipRoundedRadius: 8,
                              getTooltipItems: (List<LineBarSpot> spots) {
                                return spots.map((spot) {
                                  return LineTooltipItem(
                                    '${spot.y.toStringAsFixed(1)}%',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                            getTouchedSpotIndicator: (barData, spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: AppColors.humidity,
                                    strokeWidth: 2,
                                  ),
                                  FlDotData(
                                    getDotPainter: (spot, percent, barData, index) =>
                                      FlDotCirclePainter(
                                        radius: 5,
                                        color: AppColors.humidity,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      ),
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _ChartCard(
                title: 'Soil Moisture Levels',
                currentValue: _calculateAverageMoistureForDisplay(sensorData),
                icon: Icons.eco_outlined,
                iconColor: AppColors.soilMoisture,
                chart: SizedBox(
                  height: 220, 
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100, minY: 0,
                      barGroups: [
                        _makeBarGroupData(context, 0, sensorData.soilMoisture1.toDouble()),
                        _makeBarGroupData(context, 1, sensorData.soilMoisture2.toDouble()),
                        _makeBarGroupData(context, 2, sensorData.soilMoisture3.toDouble()),
                        _makeBarGroupData(context, 3, sensorData.soilMoisture4.toDouble()),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, reservedSize: 40,
                            interval: 20,
                            getTitlesWidget: (val, meta) => _leftTitleWidgets(context, val, meta, '%', textColor: AppColors.soilMoisture.withOpacity(0.8)),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, reservedSize: 32,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final style = AppTextStyles.chartAxis(context).copyWith(color: AppColors.soilMoisture.withOpacity(0.8));
                              return SideTitleWidget(axisSide: meta.axisSide, space: 8, child: Text('S${value.toInt() + 1}', style: style));
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true, drawVerticalLine: false, horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) => FlLine(color: AppColors.chartGridColor.withOpacity(0.5), strokeWidth: 0.7),
                      ),
                      rangeAnnotations: RangeAnnotations(
                        horizontalRangeAnnotations: [
                          HorizontalRangeAnnotation(y1: 30.0, y2: 70.0, color: AppColors.optimalRangeBackground.withOpacity(0.8)),
                          HorizontalRangeAnnotation(y1: 0, y2: 15.0, color: AppColors.soilMoistureCritical.withOpacity(0.1)),
                          HorizontalRangeAnnotation(y1: 85.0, y2: 100, color: AppColors.soilMoistureCritical.withOpacity(0.1)),
                        ],
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String sensorLabel = 'Sensor ${group.x.toInt() + 1}';
                            String statusText;
                            const double smCriticalDry = 15.0, smOptimalMin = 30.0, 
                                  smOptimalMax = 70.0, smCriticalWet = 85.0;
                            if (rod.toY < smCriticalDry) statusText = 'Critically Dry';
                            else if (rod.toY < smOptimalMin) statusText = 'Dry';
                            else if (rod.toY <= smOptimalMax) statusText = 'Optimal';
                            else if (rod.toY <= smCriticalWet) statusText = 'Wet';
                            else statusText = 'Critically Wet';
                            return BarTooltipItem(
                              '$sensorLabel\n',
                              AppTextStyles.caption(context).copyWith(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold, 
                                fontSize: 13
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${rod.toY.round()}% - $statusText',
                                  style: AppTextStyles.caption(context).copyWith(
                                    color: Colors.white, 
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            );
                          },
                          tooltipPadding: const EdgeInsets.all(10),
                          tooltipMargin: 8,
                          tooltipBgColor: AppColors.soilMoisture.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- _ChartCard Widget Definition ---
class _ChartCard extends StatelessWidget {
  final String title;
  final String currentValue;
  final IconData icon;
  final Color iconColor;
  final Widget chart;

  const _ChartCard({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.icon,
    required this.iconColor,
    required this.chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.cardBackground,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          title,
                          style: AppTextStyles.headline(context).copyWith(
                            fontSize: 20,
                            color: AppColors.textPrimary.withOpacity(0.9),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (currentValue.isNotEmpty && currentValue.toLowerCase() != 'trend')
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      currentValue,
                      style: AppTextStyles.headline(context).copyWith(
                        fontSize: 20,
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            chart,
          ],
        ),
      ),
    );
  }
}