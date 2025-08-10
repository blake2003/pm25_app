class AqiRecord {
  final String site;
  final String county;
  final int pm25;
  final DateTime datacreationdate;
  final String itemunit;

  AqiRecord({
    required this.site,
    required this.county,
    required this.pm25,
    required this.datacreationdate,
    required this.itemunit,
  });

  factory AqiRecord.fromJson(Map<String, dynamic> json) {
    return AqiRecord(
      site: json['site'] as String? ?? '',
      county: json['county'] as String? ?? '',
      datacreationdate:
          DateTime.tryParse(json['datacreationdate'] as String? ?? '') ??
              DateTime.now(),
      pm25: int.tryParse(json['pm25'] as String? ?? '') ?? 0,
      itemunit: json['itemunit'] as String? ?? 'μg/m3',
    );
  }
}
