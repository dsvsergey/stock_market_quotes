// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../l10n/app_localizations.dart';
import 'dart:math';

class QuoteChart extends StatelessWidget {
  final List<Quote> quotes;
  final AppLocalizations l10n;
  final int maxPoints;

  const QuoteChart({
    super.key,
    required this.quotes,
    required this.l10n,
    this.maxPoints = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return Center(child: Text(l10n.noDataError));
    }

    final spots = quotes
        .take(maxPoints)
        .map((quote) => FlSpot(
              quote.timestamp.millisecondsSinceEpoch.toDouble(),
              quote.value,
            ))
        .toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (meta.min == value || meta.max == value) {
                  return const SizedBox();
                }
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              interval: 2000,
              reservedSize: 32,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 0.5,
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
        minY: spots.map((s) => s.y).reduce(min) - 0.5,
        maxY: spots.map((s) => s.y).reduce(max) + 0.5,
      ),
    );
  }
}
