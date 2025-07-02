import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:intl/intl.dart';

class YoureEnvolvmentScreen extends StatefulWidget {
  const YoureEnvolvmentScreen({super.key});

  @override
  State<YoureEnvolvmentScreen> createState() => _YoureEnvolvmentScreenState();
}

class _YoureEnvolvmentScreenState extends State<YoureEnvolvmentScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    final token = context.read<UserBloc>().state.token;
    final userId = context.read<UserBloc>().state.user!.id;
    context.read<ProductBloc>().add(GetYoureEnvolvmentProductsButtonPressed(userId: userId, token: token ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swapify"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _selectedTab == 0
                ? _buildChartSection(context)
                : _buildHistorial(context),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton("Gráfica", 0),
                _buildTabButton("Historial", 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Map<String, Map<String, int>> getMonthlyStats(List<ProductEntity> products, String userId) {
    final now = DateTime.now();
    final monthLabels = List.generate(6, (i) {
      final date = DateTime(now.year, now.month - 5 + i);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}";
    });

    final stats = <String, Map<String, int>>{};
    for (final label in monthLabels) {
      stats[label] = {'buy': 0, 'sell': 0, 'swap': 0};
    }
    for (final product in products) {
      final date = product.lastUpdated ?? product.createdAt;
      final label = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      if (stats.containsKey(label)) {
        if (product.productExangedId != null) {
          stats[label]!['swap'] = stats[label]!['swap']! + 1;
        } else if (product.buyerId == userId) {
          stats[label]!['buy'] = stats[label]!['buy']! + 1;
        } else {
          stats[label]!['sell'] = stats[label]!['sell']! + 1;
        }
      }
    }
    return stats;
  }

  Widget _buildLineChart(Map<String, Map<String, int>> stats) {
  final months = stats.keys.toList();
  final buySpots = <FlSpot>[];
  final sellSpots = <FlSpot>[];
  final swapSpots = <FlSpot>[];

  for (var i = 0; i < months.length; i++) {
    final data = stats[months[i]]!;
    buySpots.add(FlSpot(i.toDouble(), data['buy']!.toDouble()));
    sellSpots.add(FlSpot(i.toDouble(), data['sell']!.toDouble()));
    swapSpots.add(FlSpot(i.toDouble(), data['swap']!.toDouble()));
  }

  final now = DateTime.now();
  final monthDates = List.generate(6, (i) {
    return DateTime(now.year, now.month - 5 + i);
  });
  final monthLabels = monthDates.map((d) => "${d.year}-${d.month.toString().padLeft(2, '0')}").toList();

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 10,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          DateFormat.MMM(Localizations.localeOf(context).languageCode).format(monthDates[index]),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                    interval: 1,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: sellSpots,
                  isCurved: true,
                  color: Colors.green,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: buySpots,
                  isCurved: true,
                  color: Colors.red,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: swapSpots,
                  isCurved: true,
                  color: Colors.orange,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendDot(Colors.red, "Compras"),
          const SizedBox(width: 10),
          _buildLegendDot(Colors.green, "Ventas"),
          const SizedBox(width: 10),
          _buildLegendDot(Colors.orange, "Intercambios"),
        ],
      ),
      ],
    ),
  );
}

Widget _buildChartSection(BuildContext context) {
  final userState = context.watch<UserBloc>().state;
  final productState = context.watch<ProductBloc>().state;

  if (userState.isLoading || productState.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (userState.user == null || productState.youreEnvolvmentProducts == null) {
    return Center(child: Text(AppLocalizations.of(context)!.errorObtainingUserInfoChat));
  }

  final userId = userState.user!.id;
  final stats = getMonthlyStats(productState.youreEnvolvmentProducts!, userId);

  return _buildLineChart(stats);
}

  Widget _buildHistorial(BuildContext context) {
    final userState = context.watch<UserBloc>().state;
    final productState = context.watch<ProductBloc>().state;

    if (userState.isLoading || productState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userState.user == null || productState.youreEnvolvmentProducts == null) {
      return Center(child: Text(AppLocalizations.of(context)!.errorObtainingUserInfoChat));
    }

    final userId = userState.user!.id;
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final products = productState.youreEnvolvmentProducts!;

    if (products.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noProductsAvailable));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isBuyer = product.buyerId == userId;
        final String transactionText = isBuyer
            ? AppLocalizations.of(context)!.youHadBoughtTheProduct
            : AppLocalizations.of(context)!.youHadSoldTheProduct;
        final Color transactionColor = isBuyer ? Colors.blue : Colors.green;
        var priceColor = isBuyer ? Colors.red : Colors.green;
        var pricePrefix = isBuyer ? "-" : "+";
        if (product.price == 0) {
          priceColor = Colors.orange;
          pricePrefix = "";
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '$baseUrl${product.images.first.path}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productBrand,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (product.productExangedId == null)
                        Text(
                          product.price == 0
                              ? AppLocalizations.of(context)!.free
                              : "$pricePrefix${AppLocalizations.of(context)!.productPrice(product.price)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: priceColor,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        product.productExangedId != null
                            ? AppLocalizations.of(context)!.dateSwaped(product.lastUpdated)
                            : isBuyer
                                ? AppLocalizations.of(context)!.dateBought(product.createdAt)
                                : AppLocalizations.of(context)!.dateSold(product.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: transactionColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: transactionColor),
                        ),
                        child: Text(
                          transactionText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: transactionColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
