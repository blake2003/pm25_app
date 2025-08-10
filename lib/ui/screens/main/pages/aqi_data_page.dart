import 'package:flutter/cupertino.dart';
import 'package:pm25_app/core/loggers/log.dart';
import 'package:pm25_app/features/aqi/aqi_provider.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';
import 'package:provider/provider.dart';

/// AQI 資料檢視頁面
class AqiDataPage extends StatelessWidget {
  const AqiDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final log = AppLogger('AqiDataScreen');
    log.d('顯示 AQI 資料檢視頁面');

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'AQI 資料檢視',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
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
                      '載入資料失敗',
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
                        color: CupertinoColors.secondaryLabel,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final records = aqiProvider.recentThreeHoursRecords;

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
                      '暫無資料',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '目前沒有最近三小時的 AQI 資料',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
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
                        '最近三小時資料',
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
                            '共 ${records.length} 筆資料',
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
                            aqiProvider.recentThreeHoursTimeRange,
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.secondaryLabel,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
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
                      return _buildAqiRecordCard(record, index);
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
  Widget _buildAqiRecordCard(AqiRecord record, int index) {
    final pm25Color = _getPm25Color(record.pm25);
    final pm25Level = _getPm25Level(record.pm25);

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
              Text(
                '記錄 #${index + 1}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.label,
                  decoration: TextDecoration.none,
                ),
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
                  'PM2.5',
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
                  label: '站點',
                  value: record.site,
                  color: const Color(0xFF007AFF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataItem(
                  icon: CupertinoIcons.map_fill,
                  label: '縣市',
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
                  label: '檢測時間',
                  value: _formatDateTime(record.datacreationdate),
                  color: const Color(0xFFAF52DE),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataItem(
                  icon: CupertinoIcons.info_circle_fill,
                  label: '健康等級',
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

  /// 根據 PM2.5 數值獲取顏色
  Color _getPm25Color(int pm25) {
    if (pm25 <= 12) return CupertinoColors.systemGreen;
    if (pm25 <= 35) return CupertinoColors.systemYellow;
    if (pm25 <= 55) return CupertinoColors.systemOrange;
    if (pm25 <= 150) return CupertinoColors.systemRed;
    return CupertinoColors.systemPurple;
  }

  /// 根據 PM2.5 數值獲取等級
  String _getPm25Level(int pm25) {
    if (pm25 <= 12) return '良好';
    if (pm25 <= 35) return '普通';
    if (pm25 <= 55) return '對敏感族群不健康';
    if (pm25 <= 150) return '對所有族群不健康';
    return '非常不健康';
  }
}
