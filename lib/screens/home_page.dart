import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'sensor_details_page.dart';
import '../plant_data_provider.dart'; // This has both SensorData and SensorDataProvider
import '../providers/farm_data_provider.dart'; // Ensure this path is correct
import '../screens/profile_page.dart';
import '../screens/contact_us_page.dart';
import '../widgets/app_drawer.dart';

// AppColors, AppTextStyles, _CustomCard, _SensorDataWidget, _StatusIcon
// and other helper build methods (_buildWeatherWidget, _buildCropCalendarWidget, etc.)
// remain largely the same as in the previous enhanced version.
// I will include them here for completeness, but the main structural change will be in HomePage.

// AppColors and AppTextStyles classes remain the same
class AppColors {
  static const Color primary = Color(0xFF4CAF50); // Richer Green
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color accent = Color(0xFFFF9800); // Vibrant Orange
  static const Color background = Color(0xFFF5F5F5); // Light Gray background
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color iconColor = Color(0xFF616161);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color soilMoistureColor = Color(0xFF5D4037);
  static const Color chartGridColor = Color(0xFFE0E0E0);
  static Color warningText = Colors.orange.shade900;
}

class AppTextStyles {
  static TextStyle headline(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          );

  static TextStyle title(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          );

  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
          );
  static TextStyle bodyRegular(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.textSecondary,
          );

  static TextStyle caption(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.textSecondary.withOpacity(0.8),
          );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Methods like _buildSectionHeader, _buildWeatherWidget, _buildCropCalendarWidget, etc.
  // are kept as they are essential for building the content within the tabs.
  // These methods will now be called within the TabBarView children.

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color iconBgColor, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBgColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconBgColor, size: 28),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: AppTextStyles.title(context),
        ),
      ],
    );
  }

  Widget _buildWeatherWidget(BuildContext context, FarmDataProvider farmData) {
    return _CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Weather Overview', Icons.wb_sunny_outlined, AppColors.accent, AppColors.accent),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmData.temperature,
                    style: AppTextStyles.headline(context).copyWith(
                      fontSize: 40,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    farmData.weatherCondition,
                    style: AppTextStyles.bodyLarge(context).copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildWeatherDetail('Humidity', farmData.humidity, Icons.water_drop_outlined),
                  const SizedBox(height: 10),
                  _buildWeatherDetail('Wind', farmData.wind, Icons.air_outlined),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCropCalendarWidget(BuildContext context, FarmDataProvider farmData) {
    return _CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Crop Calendar', Icons.calendar_today_outlined, AppColors.primary, AppColors.primary),
          const SizedBox(height: 16),
          if (farmData.cropCalendar.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: Text("No upcoming activities.", style: AppTextStyles.bodyRegular(context))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Important if the card itself is not scrollable but part of a scrollable tab
              itemCount: farmData.cropCalendar.length,
              itemBuilder: (context, index) {
                final item = farmData.cropCalendar[index];
                return _buildCalendarItem(item['activity']!, item['time']!, context);
              },
              separatorBuilder: (context, index) => const Divider(height: 20, thickness: 0.5, color: AppColors.chartGridColor),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarItem(String activity, String time, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.agriculture_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              style: AppTextStyles.bodyLarge(context).copyWith(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketPricesWidget(BuildContext context, FarmDataProvider farmData) {
    return _CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Market Prices', Icons.trending_up_outlined, AppColors.accent, AppColors.accent),
          const SizedBox(height: 16),
            if (farmData.marketPrices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: Text("Market prices not available.", style: AppTextStyles.bodyRegular(context))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: farmData.marketPrices.length,
              itemBuilder: (context, index) {
                  final item = farmData.marketPrices[index];
                return _buildPriceItem(item['crop']!, item['price']!, context);
              },
              separatorBuilder: (context, index) => const Divider(height: 20, thickness: 0.5, color: AppColors.chartGridColor),
            )
        ],
      ),
    );
  }

  Widget _buildPriceItem(String crop, String price, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.grain_outlined, color: AppColors.accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              crop,
              style: AppTextStyles.bodyLarge(context).copyWith(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              price,
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmStatsWidget(BuildContext context, FarmDataProvider farmData) {
    Color statColor = Colors.blueAccent;

    if (farmData.farmStats.isEmpty) {
      return _CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Farm Stats', Icons.bar_chart_outlined, Colors.blueGrey, Colors.blueGrey),
            const SizedBox(height: 16),
            Center(child: Text("Farm statistics not available.", style: AppTextStyles.bodyRegular(context))),
          ],
        ),
      );
    }
    return _CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Farm Stats', Icons.bar_chart_outlined, statColor, statColor),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: farmData.farmStats
                .map((item) => _buildStatItem(item['label']!, item['value']!, context, _getStatIcon(item['label']!), statColor))
                .toList(),
          ),
        ],
      ),
    );
  }

  IconData _getStatIcon(String label) {
    switch (label.toLowerCase()) {
      case 'total crops':
        return Icons.eco_outlined;
      case 'land area':
        return Icons.fullscreen_outlined;
      case 'water usage':
        return Icons.opacity_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildStatItem(String label, String value, BuildContext context, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.title(context).copyWith(
            color: color,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.caption(context),
        ),
      ],
    );
  }

  Widget _buildQuickTipsWidget(BuildContext context, FarmDataProvider farmData) {
    Color tipColor = Colors.teal;

    return _CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Quick Tips', Icons.lightbulb_outline, tipColor, tipColor),
          const SizedBox(height: 16),
          if (farmData.quickTips.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: Text("No tips available right now.", style: AppTextStyles.bodyRegular(context))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: farmData.quickTips.length,
              itemBuilder: (context, index){
                final tip = farmData.quickTips[index];
                return _buildTipItem(tip, context, tipColor);
              },
              separatorBuilder: (context, index) => const Divider(height: 20, thickness: 0.5, color: AppColors.chartGridColor),
            )
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip, BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodyLarge(context).copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final farmData = Provider.of<FarmDataProvider>(context);

    // Define the tabs
    final List<Tab> myTabs = <Tab>[
      const Tab(text: 'Dashboard', icon: Icon(Icons.dashboard_outlined)),
      const Tab(text: 'Schedule', icon: Icon(Icons.calendar_today_outlined)),
      const Tab(text: 'Market', icon: Icon(Icons.show_chart_outlined)),
      const Tab(text: 'Insights', icon: Icon(Icons.insights_outlined)),
    ];

    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text(
            'AgriCure',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 1.0,
          bottom: TabBar(
            tabs: myTabs,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: AppTextStyles.headline(context).copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Here's your farm's current status.",
                    style: AppTextStyles.bodyRegular(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent(context, children: [
                    _SensorDataWidget(),
                    const SizedBox(height: 20),
                    _buildWeatherWidget(context, farmData),
                  ]),
                  _buildTabContent(context, children: [
                    _buildCropCalendarWidget(context, farmData),
                  ]),
                  _buildTabContent(context, children: [
                    _buildMarketPricesWidget(context, farmData),
                  ]),
                  _buildTabContent(context, children: [
                    _buildFarmStatsWidget(context, farmData),
                    const SizedBox(height: 20),
                    _buildQuickTipsWidget(context, farmData),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build scrollable content for each tab
  Widget _buildTabContent(BuildContext context, {required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}


// _CustomCard class remains the same
class _CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const _CustomCard({required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: AppColors.cardBackground,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20.0),
          child: child,
        ),
      ),
    );
  }
}

// _SensorDataWidget and its State (_SensorDataWidgetState) remain the same
// as the previously enhanced version (with internal builder methods like _buildHeader,
// _buildLoadingIndicator, _buildErrorContent, _buildNoDataContent, _buildDataContent, etc.)
class _SensorDataWidget extends StatefulWidget {
  @override
  State<_SensorDataWidget> createState() => _SensorDataWidgetState();
}

class _SensorDataWidgetState extends State<_SensorDataWidget> {
  bool _fetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      _fetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Provider.of<SensorDataProvider>(context, listen: false).fetchSensorData();
        }
      });
    }
  }

  Color _getStatusColor(SensorData data) {
    final lowMoisture = _isAnySoilMoistureLow(data);
    final lowHumidity = data.humidity < 30;
    final lowTemp = data.temperature < 5;
    final highTemp = data.temperature > 35;

    if (lowMoisture || lowHumidity || lowTemp || highTemp) return AppColors.warning;
    return AppColors.success;
  }

  String _getStatusMessage(SensorData data) {
    List<String> issues = [];
    if (_isAnySoilMoistureLow(data)) issues.add("low soil moisture");
    if (data.humidity < 30) issues.add("low humidity");
    if (data.temperature < 5) issues.add("low temperature");
    if (data.temperature > 35) issues.add("high temperature");

    if (issues.isEmpty) return 'All systems normal. Everything looks good!';
    if (issues.length == 1) return 'Attention: ${issues.first} detected.';
    if (issues.length == 2) return 'Attention: ${issues.join(' and ')} detected.';
    return 'Multiple issues: ${issues.join(', ')}. Please check details.';
  }

   bool _isAnySoilMoistureLow(SensorData data) {
    return data.soilMoisture1 < 30 || data.soilMoisture2 < 30 || data.soilMoisture3 < 30 || data.soilMoisture4 < 30;
  }

  String _lowestMoistureLabel(SensorData data) {
    final lowest = _lowestMoistureValue(data);
    if (lowest < 20) return 'Critical';
    if (lowest < 30) return 'Low';
    return 'OK';
  }

  int _lowestMoistureValue(SensorData data) {
    final values = [data.soilMoisture1, data.soilMoisture2, data.soilMoisture3, data.soilMoisture4];
    return values.reduce((a, b) => a < b ? a : b);
  }

  Widget _buildHeader(BuildContext context, SensorDataProvider provider, SensorData? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sensors, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Text('Sensor Overview', style: AppTextStyles.title(context)),
          ],
        ),
        if (data != null || provider.error != null)
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.iconColor),
            onPressed: () => provider.fetchSensorData(),
            tooltip: 'Refresh Data',
          ),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 40),
            const SizedBox(height: 12),
            Text(
              error,
              style: AppTextStyles.bodyLarge(context).copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Retry"),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Text(
          'No sensor data available.',
          style: AppTextStyles.bodyRegular(context).copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildStatusSummary(BuildContext context, SensorData data) {
    final statusColor = _getStatusColor(data);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.5)),
        color: statusColor.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(
            statusColor == AppColors.success ? Icons.check_circle_outline : Icons.warning_amber_outlined,
            color: statusColor,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getStatusMessage(data),
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: statusColor == AppColors.success ? AppColors.success : AppColors.warningText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingsOverview(BuildContext context, SensorData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Key Readings",
          style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatusIcon(
              icon: Icons.thermostat_outlined,
              label: '${data.temperature}°C',
              status: data.temperature < 5 ? 'Low' : (data.temperature > 35 ? 'High' : 'OK'),
              baseColor: Colors.orange,
            ),
            _StatusIcon(
              icon: Icons.water_drop_outlined,
              label: '${data.humidity}%',
              status: data.humidity < 30 ? 'Low' : 'OK',
              baseColor: Colors.blue,
            ),
            _StatusIcon(
              icon: Icons.eco_outlined,
              label: '${_lowestMoistureValue(data)}%',
              status: _lowestMoistureLabel(data),
              baseColor: AppColors.soilMoistureColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataContent(BuildContext context, SensorData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusSummary(context, data),
        const SizedBox(height: 24),
        _buildReadingsOverview(context, data),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Tap for more details →',
            style: AppTextStyles.caption(context).copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
  
  BarChartGroupData _makeBarGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorDataProvider>(context);
    final data = sensorProvider.sensorData;

    return _CustomCard(
      onTap: data != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SensorDetailsPage(
                    sensorData: data,
                    sensorProvider: sensorProvider, 
                  ),
                ),
              );
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, sensorProvider, data),
          const SizedBox(height: 20),
          if (sensorProvider.isLoading)
            _buildLoadingIndicator(context)
          else if (sensorProvider.error != null)
            _buildErrorContent(context, sensorProvider.error!, () => sensorProvider.fetchSensorData())
          else if (data == null)
            _buildNoDataContent(context)
          else
            _buildDataContent(context, data),
        ],
      ),
    );
  }
}

// _StatusIcon widget remains the same
class _StatusIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final Color baseColor;

  const _StatusIcon({
    required this.icon,
    required this.label,
    required this.status,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'low':
      case 'critical':
      case 'high':
        statusColor = AppColors.warning;
        break;
      case 'ok':
      default:
        statusColor = AppColors.success;
        break;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: baseColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: statusColor, width: 1.5),
          ),
          child: Icon(icon, size: 26, color: baseColor),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 14)),
        const SizedBox(height: 2),
        Text(
          status,
          style: AppTextStyles.caption(context).copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}