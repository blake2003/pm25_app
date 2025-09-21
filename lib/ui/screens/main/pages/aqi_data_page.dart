import 'package:flutter/cupertino.dart';
import 'package:pm25_app/core/constants/language/l10n/app_localizations.dart';
import 'package:pm25_app/core/constants/pm25_color.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';
import 'package:provider/provider.dart';

/// AQI 資料檢視頁面
class AqiDataPage extends StatelessWidget {
  const AqiDataPage({super.key});

  /// 顯示時間過濾選擇器
  void _showTimeFilterPicker(BuildContext context, AqiProvider aqiProvider) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.selectTimeRange),
        message: Text(AppLocalizations.of(context)!.selectTimeRangeMessage),
        actions: aqiProvider.availableTimeFilters.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              aqiProvider.setTimeFilter(option);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(option.label),
                if (option == aqiProvider.selectedTimeFilter)
                  const Icon(
                    CupertinoIcons.check_mark,
                    color: CupertinoColors.systemBlue,
                    size: 16,
                  ),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final log = AppLogger('AqiDataScreen');
    log.d('顯示 AQI 資料檢視頁面');

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context)!.aqiDataView,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        trailing: Consumer<AqiProvider>(
          builder: (context, aqiProvider, child) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _showTimeFilterPicker(context, aqiProvider);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.clock_fill,
                    size: 20,
                    color: CupertinoColors.systemBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    aqiProvider.selectedTimeFilter.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 12,
                    color: CupertinoColors.systemBlue,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Consumer<AqiProvider>(
          builder: (context, aqiProvider, child) {
            if (aqiProvider.isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              );
            }

            if (aqiProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.exclamationmark_circle,
                      size: 64,
                      color: CupertinoColors.systemRed,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.loadDataFailed,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      aqiProvider.error!,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final records = aqiProvider.filteredRecords;

            if (records.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.doc_text,
                      size: 64,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noData,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.noDataMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // 標題資訊
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CupertinoColors.separator,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aqiProvider.selectedTimeRangeDescription,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: CupertinoColors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.doc_text,
                            size: 16,
                            color: CupertinoColors.systemBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)!
                                .totalRecords(records.length),
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.secondaryLabel,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 16,
                            color: CupertinoColors.systemGreen,
                            // iOS CupertinoIcon 沒有 fill 屬性，若要顏色填充滿，需用 filled 版本
                          ),
                          const SizedBox(width: 6),
                          Text(
                            aqiProvider.filteredRecordsTimeRange,
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.secondaryLabel,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      // 新增除錯資訊
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.info_circle,
                              size: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.originalData(
                                    aqiProvider.records.length, records.length),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemGrey,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (aqiProvider.records.length > records.length) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                CupertinoColors.systemOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color:
                                  CupertinoColors.systemOrange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_triangle,
                                size: 14,
                                color: CupertinoColors.systemOrange,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .dataFilteredWarning,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.systemOrange,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // 資料列表
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return _buildAqiRecordCard(
                          context, record, index, aqiProvider);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 建立 AQI 記錄卡片
  Widget _buildAqiRecordCard(BuildContext context, AqiRecord record, int index,
      AqiProvider aqiProvider) {
    final pm25Color = PM25Color.getPm25Color(record.pm25);
    final pm25Level = PM25Color.getPm25Level(record.pm25);

    final isInSelectedTimeRange =
        aqiProvider.isRecordInSelectedTimeRange(record);
    final hasTimeFilter = aqiProvider.selectedTimeFilter.duration != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: pm25Color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pm25Color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: pm25Color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 標題行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.recordNumber(index + 1),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.label,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  if (hasTimeFilter && !isInSelectedTimeRange) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.older,
                        style: TextStyle(
                          fontSize: 10,
                          color: CupertinoColors.systemGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: pm25Color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: pm25Color.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  // 健康等級
                  pm25Level,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: pm25Color,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // PM2.5 數值 - 中間重點顯示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: pm25Color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: pm25Color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // PM2.5 標籤
                Text(
                  AppLocalizations.of(context)!.pm25Label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.secondaryLabel,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 8),
                // 數值顯示
                Text(
                  '${record.pm25} ${record.itemunit}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: pm25Color,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 站點和縣市資訊 - 下方顯示
          Row(
            children: [
              Expanded(
                child: _buildDataItem(
                  icon: CupertinoIcons.location_fill,
                  label: AppLocalizations.of(context)!.site,
                  //TODO: 需要翻譯 value
                  value: record.site,
                  color: const Color(0xFF007AFF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataItem(
                  icon: CupertinoIcons.map_fill,
                  label: AppLocalizations.of(context)!.county,
                  value: record.county,
                  color: const Color(0xFF34C759),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 檢測時間和健康等級 - 最下方顯示
          Row(
            children: [
              Expanded(
                child: _buildDataItem(
                  icon: CupertinoIcons.time_solid,
                  label: AppLocalizations.of(context)!.detectionTime,
                  value: _formatDateTime(record.datacreationdate),
                  color: const Color(0xFFAF52DE),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataItem(
                  icon: CupertinoIcons.info_circle_fill,
                  label: AppLocalizations.of(context)!.healthLevel,
                  value: pm25Level,
                  color: pm25Color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 建立資料項目
  Widget _buildDataItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
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
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  /// 格式化日期時間
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // PM2.5 相關方法已移至 PM25Utils 工具類別
}
