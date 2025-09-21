import 'package:flutter/cupertino.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/core/constants/pm25_color.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/ui/screens/main/pages/aqi_data_page.dart';

/// 最近三個小時資料統計卡片 Widget
class RecentDataCard extends StatelessWidget {
  final AqiProvider provider;

  const RecentDataCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final recentCount = provider.filteredRecordsCount;
    final averagePm25 = provider.filteredRecordsAveragePm25;
    final timeRange = provider.filteredRecordsTimeRange;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.chart_bar_alt_fill,
                    color: CupertinoColors.systemBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!
                      .recentThreeHoursStats, //“最近三個小時統計”
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.doc_text,
                    label: AppLocalizations.of(context)!.dataCount, //“資料筆數”
                    value: AppLocalizations.of(context)!
                        .dataCountUnit(recentCount),
                    color: CupertinoColors.systemBlue,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const AqiDataPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.chart_bar,
                    label:
                        AppLocalizations.of(context)!.averagePM25, //“平均ＰＭ２.５”
                    value: '${averagePm25.toStringAsFixed(1)} μg/m³',
                    color: PM25Color.getPm25Color(averagePm25.round()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: CupertinoIcons.clock,
                    label: AppLocalizations.of(context)!.timeRange, //“時間範圍”
                    value: timeRange,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 建立統計項目 - iOS 風格
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    Widget content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.secondaryLabel,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onTap != null) ...[
                const Spacer(),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 12,
                  color: CupertinoColors.systemGrey,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: content,
      );
    }

    return content;
  }
}
