// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/statistics.dart';

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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.5),
            1: FlexColumnWidth(1.0),
          },
          children: [
            _buildHeaderRow(theme, l10n),
            _buildDataRow(l10n.mean, statistics.mean.toStringAsFixed(2), theme),
            _buildDataRow(l10n.standardDeviation,
                statistics.standardDeviation.toStringAsFixed(2), theme),
            _buildDataRow(l10n.mode, statistics.mode.toStringAsFixed(2), theme),
            _buildDataRow(
                l10n.median, statistics.median.toStringAsFixed(2), theme),
            _buildDataRow(
                l10n.lostQuotes, statistics.lostQuotes.toString(), theme,
                valueColor: theme.colorScheme.error),
            _buildDataRow(
              l10n.calculationTime,
              '${statistics.calculationTime.inMilliseconds} ${l10n.milliseconds}',
              theme,
              valueColor: theme.colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildHeaderRow(ThemeData theme, AppLocalizations l10n) {
    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      children: [
        _buildCell(
          l10n.statisticsTable,
          theme,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildCell(
          '',
          theme,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  TableRow _buildDataRow(String label, String value, ThemeData theme,
      {Color? valueColor}) {
    return TableRow(
      children: [
        _buildCell(
          label,
          theme,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        _buildCell(
          value,
          theme,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            color: valueColor ?? theme.colorScheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text, ThemeData theme, {TextStyle? textStyle}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 20.0,
      ),
      child: Text(
        text,
        style: textStyle ?? theme.textTheme.bodyMedium,
      ),
    );
  }
}
