// lib/ui/widgets/aqi_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm25_app/features/aqi/aqi_record%EF%BC%BFmodel.dart';

class AqiCard extends StatelessWidget {
  const AqiCard({
    super.key,
    required this.record,
  });

  final AqiRecord record;

  Color _colorByPm25(int? pm) {
    if (pm == null) return Colors.grey;
    if (pm <= 15) return Colors.green;
    if (pm <= 35) return Colors.yellow[700]!;
    if (pm <= 54) return Colors.orange;
    if (pm <= 150) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorByPm25(record.pm25);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              record.site,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              record.pm25.toString(),
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(record.itemunit),
            const SizedBox(height: 16),
            Text(
              '更新時間：${DateFormat('yyyy/MM/dd HH:mm').format(record.datacreationdate)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
