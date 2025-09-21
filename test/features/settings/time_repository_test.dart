import 'package:flutter_test/flutter_test.dart';
import 'package:pm25_app/features/settings/theme/auto_theme/time_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TimeRepository', () {
    late TimeRepository timeRepository;

    setUp(() {
      timeRepository = TimeRepository();
      // 清除 SharedPreferences 的測試資料
      SharedPreferences.setMockInitialValues({});
    });

    group('getDayStartTime', () {
      test('應該返回預設的白天開始時間', () async {
        // Arrange & Act
        final result = await timeRepository.getDayStartTime();

        // Assert
        expect(result['hour'], equals(7));
        expect(result['minute'], equals(0));
      });

      test('應該返回儲存的白天開始時間', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'dayStartTime_hour': 8,
          'dayStartTime_minute': 30,
        });

        // Act
        final result = await timeRepository.getDayStartTime();

        // Assert
        expect(result['hour'], equals(8));
        expect(result['minute'], equals(30));
      });
    });

    group('getNightStartTime', () {
      test('應該返回預設的夜晚開始時間', () async {
        // Arrange & Act
        final result = await timeRepository.getNightStartTime();

        // Assert
        expect(result['hour'], equals(19));
        expect(result['minute'], equals(0));
      });

      test('應該返回儲存的夜晚開始時間', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'nightStartTime_hour': 20,
          'nightStartTime_minute': 15,
        });

        // Act
        final result = await timeRepository.getNightStartTime();

        // Assert
        expect(result['hour'], equals(20));
        expect(result['minute'], equals(15));
      });
    });

    group('saveDayStartTime', () {
      test('應該成功儲存有效的白天開始時間', () async {
        // Arrange
        const hour = 8;
        const minute = 30;

        // Act
        await timeRepository.saveDayStartTime(hour, minute);

        // Assert
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('dayStartTime_hour'), equals(hour));
        expect(prefs.getInt('dayStartTime_minute'), equals(minute));
      });

      test('應該拋出錯誤當小時超出範圍', () async {
        // Arrange
        const invalidHour = 25;
        const minute = 30;

        // Act & Assert
        expect(
          () => timeRepository.saveDayStartTime(invalidHour, minute),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('應該拋出錯誤當分鐘超出範圍', () async {
        // Arrange
        const hour = 8;
        const invalidMinute = 60;

        // Act & Assert
        expect(
          () => timeRepository.saveDayStartTime(hour, invalidMinute),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('saveNightStartTime', () {
      test('應該成功儲存有效的夜晚開始時間', () async {
        // Arrange
        const hour = 20;
        const minute = 15;

        // Act
        await timeRepository.saveNightStartTime(hour, minute);

        // Assert
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('nightStartTime_hour'), equals(hour));
        expect(prefs.getInt('nightStartTime_minute'), equals(minute));
      });

      test('應該拋出錯誤當小時超出範圍', () async {
        // Arrange
        const invalidHour = -1;
        const minute = 15;

        // Act & Assert
        expect(
          () => timeRepository.saveNightStartTime(invalidHour, minute),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('應該拋出錯誤當分鐘超出範圍', () async {
        // Arrange
        const hour = 20;
        const invalidMinute = -1;

        // Act & Assert
        expect(
          () => timeRepository.saveNightStartTime(hour, invalidMinute),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('clearAllTimeSettings', () {
      test('應該清除所有時間設定', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'dayStartTime_hour': 8,
          'dayStartTime_minute': 30,
          'nightStartTime_hour': 20,
          'nightStartTime_minute': 15,
        });

        // Act
        await timeRepository.clearAllTimeSettings();

        // Assert
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('dayStartTime_hour'), isNull);
        expect(prefs.getInt('dayStartTime_minute'), isNull);
        expect(prefs.getInt('nightStartTime_hour'), isNull);
        expect(prefs.getInt('nightStartTime_minute'), isNull);
      });
    });

    group('hasStoredTimeSettings', () {
      test('應該返回 false 當沒有儲存的設定', () async {
        // Arrange & Act
        final result = await timeRepository.hasStoredTimeSettings();

        // Assert
        expect(result, isFalse);
      });

      test('應該返回 true 當有完整的時間設定', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'dayStartTime_hour': 8,
          'nightStartTime_hour': 20,
        });

        // Act
        final result = await timeRepository.hasStoredTimeSettings();

        // Assert
        expect(result, isTrue);
      });

      test('應該返回 false 當只有部分時間設定', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'dayStartTime_hour': 8,
          // 缺少 nightStartTime_hour
        });

        // Act
        final result = await timeRepository.hasStoredTimeSettings();

        // Assert
        expect(result, isFalse);
      });
    });

    group('getDefaultTimes', () {
      test('應該返回預設時間設定', () {
        // Arrange & Act
        final result = timeRepository.getDefaultTimes();

        // Assert
        expect(result['dayStart']!['hour'], equals(7));
        expect(result['dayStart']!['minute'], equals(0));
        expect(result['nightStart']!['hour'], equals(19));
        expect(result['nightStart']!['minute'], equals(0));
      });
    });

    group('邊界值測試', () {
      test('應該接受最小有效時間 (0:00)', () async {
        // Arrange
        const hour = 0;
        const minute = 0;

        // Act & Assert
        expect(
          () => timeRepository.saveDayStartTime(hour, minute),
          returnsNormally,
        );
        expect(
          () => timeRepository.saveNightStartTime(hour, minute),
          returnsNormally,
        );
      });

      test('應該接受最大有效時間 (23:59)', () async {
        // Arrange
        const hour = 23;
        const minute = 59;

        // Act & Assert
        expect(
          () => timeRepository.saveDayStartTime(hour, minute),
          returnsNormally,
        );
        expect(
          () => timeRepository.saveNightStartTime(hour, minute),
          returnsNormally,
        );
      });
    });
  });
}
