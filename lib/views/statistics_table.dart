import 'package:flutter/material.dart';
import '../models/statistics.dart';
import '../l10n/app_localizations.dart';

class StatisticsTable extends StatelessWidget {
  final Statistics statistics;
  final AppLocalizations l10n;

  const StatisticsTable({
    super.key,
    required this.statistics,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.0),
      },
      children: [
        _buildRow(l10n.mean, statistics.mean.toStringAsFixed(2)),
        _buildRow(l10n.standardDeviation,
            statistics.standardDeviation.toStringAsFixed(2)),
        _buildRow(l10n.mode, statistics.mode.toStringAsFixed(2)),
        _buildRow(l10n.median, statistics.median.toStringAsFixed(2)),
        _buildRow(l10n.lostQuotes, statistics.lostQuotes.toString()),
        _buildRow(
          l10n.calculationTime,
          '${statistics.calculationTime.inMilliseconds} ${l10n.milliseconds}',
        ),
      ],
    );
  }

  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(value),
        ),
      ],
    );
  }
}
