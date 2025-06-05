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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('SensorDetailsPage initialized');
    _updateChartData();
    print('Setting up refresh timer');
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && !_isLoading) {
        _refreshData();
      }
    });
  }

  void _updateChartData() {
    if (!mounted) return;
    setState(() {
      // Get the history data and sort it by timestamp
      final tempHistory = widget.sensorData.temperatureHistory;
      final humidHistory = widget.sensorData.humidityHistory;

      // Convert history to spots for the charts
      if (tempHistory.isNotEmpty) {
        _tempSpots = List.generate(tempHistory.length, (index) {
          return FlSpot(index.toDouble(), tempHistory[index].value);
        });
      } else {
        // If no history, just show current value
        _tempSpots = [FlSpot(0, widget.sensorData.temperature.toDouble())];
      }

      if (humidHistory.isNotEmpty) {
        _humiditySpots = List.generate(humidHistory.length, (index) {
          return FlSpot(index.toDouble(), humidHistory[index].value);
        });
      } else {
        // If no history, just show current value
        _humiditySpots = [FlSpot(0, widget.sensorData.humidity.toDouble())];
      }
    });
  }

  Future<void> _refreshData() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.sensorProvider.fetchSensorData();
      if (mounted) {
        setState(() {
          _lastUpdate = DateTime.now();
          _updateChartData();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error refreshing sensor data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(SensorDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update charts when new data arrives
    if (oldWidget.sensorData != widget.sensorData) {
      _updateChartData();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
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
            icon: _isLoading 
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary.withOpacity(0.8)),
                  ),
                )
              : Icon(Icons.refresh, color: AppColors.primary.withOpacity(0.8)),
            onPressed: _isLoading ? null : _refreshData,
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
      currentValue: '${sensorData.temperature.toStringAsFixed(1)}°C',
      icon: Icons.thermostat_outlined,
      iconColor: AppColors.temperature,
      chart: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${sensorData.temperature.toStringAsFixed(1)}°C',
                style: AppTextStyles.display(context).copyWith(
                  color: AppColors.temperature,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: sensorData.temperature >= 18 && sensorData.temperature <= 25
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.temperature.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getTemperatureStatus(sensorData.temperature.toDouble()),
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: sensorData.temperature >= 18 && sensorData.temperature <= 25
                          ? AppColors.primary
                          : AppColors.temperature,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: 15,
                maxY: 35,
                lineBarsData: [
                  LineChartBarData(
                    spots: _tempSpots,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    barWidth: 3.5,
                    color: AppColors.temperature,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        bool isLastDot = index == barData.spots.length - 1;
                        return FlDotCirclePainter(
                          radius: isLastDot ? 6 : 4.5,
                          color: AppColors.temperature.withOpacity(isLastDot ? 1.0 : 0.9),
                          strokeWidth: 1.5,
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
                          AppColors.temperature.withOpacity(0.45),
                          AppColors.temperature.withOpacity(0.15),
                          AppColors.temperature.withOpacity(0.02),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                    shadow: Shadow(
                      blurRadius: 8.0,
                      color: AppColors.temperature.withOpacity(0.35),
                      offset: const Offset(2, 4),
                    ),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.chartGridColor.withOpacity(0.1),
                    strokeWidth: 1,
                    dashArray: [3, 3],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 5,
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
                      showTitles: true,
                      reservedSize: 35,
                      interval: 2,
                      getTitlesWidget: (val, meta) {
                        if (val.toInt() % 2 == 0 && val <= _tempSpots.last.x) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 10.0,
                            child: Text(
                              '${val.toInt()}h',
                              style: AppTextStyles.caption(context).copyWith(
                                color: AppColors.temperature.withOpacity(0.85),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.chartGridColor.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppColors.temperature.withOpacity(0.85),
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toStringAsFixed(1)}°C  ',
                          AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        );
                      }).toList();
                    },
                  ),
                ),
                rangeAnnotations: RangeAnnotations(
                  horizontalRangeAnnotations: [
                    HorizontalRangeAnnotation(
                      y1: 18.0,
                      y2: 25.0,
                      color: AppColors.optimalTemperatureRange.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  

              const SizedBox(height: 20),
              _ChartCard(
                title: 'Humidity',
                currentValue: '${sensorData.humidity.toStringAsFixed(1)}%',
                icon: Icons.water_drop_outlined,
                iconColor: AppColors.humidity,
                chart: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sensorData.humidity.toStringAsFixed(1)}%',
                      style: AppTextStyles.display(context).copyWith(
                        color: AppColors.humidity,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sensorData.humidity < 30 ? "Very Dry" :
                      sensorData.humidity < 40 ? "Dry" :
                      sensorData.humidity <= 60 ? "Optimal" :
                      sensorData.humidity <= 70 ? "Humid" : "Very Humid",
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        color: AppColors.textSecondary.withOpacity(0.9),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _humiditySpots,
                              isCurved: true,
                              curveSmoothness: 0.4,
                              barWidth: 3.5,
                              color: AppColors.humidity,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  bool isLastDot = index == barData.spots.length - 1;
                                  return FlDotCirclePainter(
                                    radius: isLastDot ? 6 : 4.5,
                                    color: AppColors.humidity.withOpacity(isLastDot ? 1.0 : 0.9),
                                    strokeWidth: 1.5,
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
                                    AppColors.humidity.withOpacity(0.45),
                                    AppColors.humidity.withOpacity(0.15),
                                    AppColors.humidity.withOpacity(0.02),
                                  ],
                                  stops: const [0.0, 0.6, 1.0],
                                ),
                              ),
                              shadow: Shadow(
                                blurRadius: 8.0,
                                color: AppColors.humidity.withOpacity(0.35),
                                offset: const Offset(2, 4),
                              ),
                            ),
                          ],
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: AppColors.chartGridColor.withOpacity(0.1),
                              strokeWidth: 1,
                              dashArray: [3, 3],
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 45,
                                interval: 20,
                                getTitlesWidget: (val, meta) => _leftTitleWidgets(
                                  context,
                                  val,
                                  meta,
                                  '%',
                                  textColor: AppColors.humidity.withOpacity(0.7),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 2,
                                getTitlesWidget: (val, meta) {
                                  if (val.toInt() % 2 == 0 && val <= _humiditySpots.last.x) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 10.0,
                                      child: Text(
                                        '${val.toInt()}h',
                                        style: AppTextStyles.caption(context).copyWith(
                                          color: AppColors.humidity.withOpacity(0.85),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: AppColors.chartGridColor.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: AppColors.humidity.withOpacity(0.85),
                              tooltipRoundedRadius: 8,
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  return LineTooltipItem(
                                    '${barSpot.y.toStringAsFixed(1)}%  ',
                                    AppTextStyles.bodyLarge(context).copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          rangeAnnotations: RangeAnnotations(
                            horizontalRangeAnnotations: [
                              HorizontalRangeAnnotation(
                                y1: 40.0,
                                y2: 60.0,
                                color: AppColors.optimalHumidityRange.withOpacity(0.3),
                              ),
                            ],
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
                      maxY: 100,
                      minY: 0,
                      barGroups: [
                        _makeEnhancedBarGroupData(context, 0, sensorData.soilMoisture1.toDouble()),
                        _makeEnhancedBarGroupData(context, 1, sensorData.soilMoisture2.toDouble()),
                        _makeEnhancedBarGroupData(context, 2, sensorData.soilMoisture3.toDouble()),
                        _makeEnhancedBarGroupData(context, 3, sensorData.soilMoisture4.toDouble()),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            interval: 25,
                            getTitlesWidget: (val, meta) => _leftTitleWidgets(
                              context,
                              val,
                              meta,
                              '%',
                              textColor: AppColors.soilMoisture.withOpacity(0.8),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final style = AppTextStyles.chartAxis(context).copyWith(
                                color: AppColors.soilMoisture.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              );
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8,
                                child: Text('S${value.toInt() + 1}', style: style),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.chartGridColor.withOpacity(0.4),
                          strokeWidth: 0.7,
                        ),
                      ),
                      rangeAnnotations: RangeAnnotations(
                        horizontalRangeAnnotations: [
                          HorizontalRangeAnnotation(
                            y1: 30.0,
                            y2: 70.0,
                            color: AppColors.optimalRangeBackground.withOpacity(0.4),
                          ),
                          HorizontalRangeAnnotation(
                            y1: 0,
                            y2: 15.0,
                            color: AppColors.soilMoistureCritical.withOpacity(0.3),
                          ),
                          HorizontalRangeAnnotation(
                            y1: 85.0,
                            y2: 100,
                            color: AppColors.soilMoistureCritical.withOpacity(0.3),
                          ),
                        ],
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8.0,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String sensorLabel = 'Sensor ${group.x.toInt() + 1}';
                            String statusText;
                            const double smCriticalDry = 15.0,
                                smOptimalMin = 30.0,
                                smOptimalMax = 70.0,
                                smCriticalWet = 85.0;
                            final double currentY = rod.toY;

                            if (currentY < smCriticalDry) statusText = 'Critically Dry';
                            else if (currentY < smOptimalMin) statusText = 'Dry';
                            else if (currentY <= smOptimalMax) statusText = 'Optimal';
                            else if (currentY <= smCriticalWet) statusText = 'Wet';
                            else statusText = 'Critically Wet';

                            return BarTooltipItem(
                              '$sensorLabel\n',
                              AppTextStyles.bodyLarge(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${currentY.round()}% - $statusText',
                                  style: AppTextStyles.caption(context).copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            );
                          },
                          tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

  BarChartGroupData _makeEnhancedBarGroupData(BuildContext context, int x, double y) {
    final screenWidth = MediaQuery.of(context).size.width;
    final barColor = _getSoilMoistureBarColor(y);
    final lightBarColor = barColor.withOpacity(0.7);
    
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.isNaN || y.isInfinite ? 0 : y,
          gradient: LinearGradient(
            colors: [
              lightBarColor,
              barColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: screenWidth * 0.04,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: barColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ],
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