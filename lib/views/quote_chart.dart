// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../l10n/app_localizations.dart';

class QuoteChart extends StatelessWidget {
  final List<Quote> quotes;
  final AppLocalizations l10n;

  const QuoteChart({
    super.key,
    required this.quotes,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return Center(child: Text(l10n.noDataError));
    }

    final spots = quotes.map((quote) {
      return FlSpot(
        quote.timestamp.millisecondsSinceEpoch.toDouble(),
        quote.value,
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${date.hour}:${date.minute}:${date.second}',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
