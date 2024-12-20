// ignore_for_file: deprecated_member_use

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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(
            color: theme.dividerColor.withOpacity(0.2),
          ),
        ),
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1.0),
        },
        children: [
          _buildHeaderRow(theme),
          _buildRow(l10n.mean, statistics.mean.toStringAsFixed(2), theme),
          _buildRow(l10n.standardDeviation,
              statistics.standardDeviation.toStringAsFixed(2), theme),
          _buildRow(l10n.mode, statistics.mode.toStringAsFixed(2), theme),
          _buildRow(l10n.median, statistics.median.toStringAsFixed(2), theme),
          _buildRow(l10n.lostQuotes, statistics.lostQuotes.toString(), theme,
              valueColor:
                  statistics.lostQuotes > 0 ? Colors.red : Colors.green),
          _buildRow(
            l10n.calculationTime,
            '${statistics.calculationTime.inMilliseconds} ${l10n.milliseconds}',
            theme,
            valueColor: statistics.calculationTime.inMilliseconds > 100
                ? Colors.orange
                : Colors.green,
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow(ThemeData theme) {
    return TableRow(
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
      ),
      children: [
        _buildCell(
          l10n.statisticsTable,
          theme,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        _buildCell('', theme),
      ],
    );
  }

  TableRow _buildRow(String label, String value, ThemeData theme,
      {Color? valueColor}) {
    return TableRow(
      children: [
        _buildCell(
          label,
          theme,
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
          ),
        ),
        _buildCell(
          value,
          theme,
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text, ThemeData theme, {TextStyle? textStyle}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          text,
          key: ValueKey(text),
          style: textStyle ?? theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
