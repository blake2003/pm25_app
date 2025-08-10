import 'package:pm25_app/core/services/data_service.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';

class AqiRepository {
  AqiRepository({DataService? dataService})
      : _dataService = dataService ?? DataService();
  final DataService _dataService;

  /// 依照站點名稱取得最新 AQI 資料
  Future<List<AqiRecord>> getSiteAqi(String site) async {
    final raw = await _dataService.fetchSiteData(site);
    // 轉成強型別，過濾掉非預期欄位
    return raw
        .map((e) => AqiRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
