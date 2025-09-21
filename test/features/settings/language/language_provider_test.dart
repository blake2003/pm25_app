import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
import 'package:pm25_app/core/constants/language/language_constants.dart';
import 'package:pm25_app/features/settings/language/language_provider.dart';
import 'package:pm25_app/features/settings/language/language_repository.dart';

// import 'language_provider_test.mocks.dart';

@GenerateMocks([LanguageRepository])
void main() {
  group('LanguageProvider Tests', () {
    late LanguageProvider languageProvider;
    // late MockLanguageRepository mockRepository;

    setUp(() {
      // mockRepository = MockLanguageRepository();
      languageProvider = LanguageProvider();
      // 注入 mock repository（這裡需要修改 LanguageProvider 以支援依賴注入）
    });

    group('初始化測試', () {
      test('應該使用預設語言初始化', () {
        expect(languageProvider.currentLanguage,
            LanguageConstants.defaultLanguage);
        expect(languageProvider.isLoading, false);
        expect(languageProvider.error, null);
      });

      test('應該有支援的語言清單', () {
        expect(languageProvider.supportedLanguages, isNotEmpty);
        expect(languageProvider.supportedLanguages.length, greaterThan(0));
      });
    });

    // TODO: 需要先實現依賴注入才能進行這些測試
    // group('語言切換測試', () {
    //   test('應該成功切換到支援的語言', () async {
    //     // Arrange
    //     const newLanguage = 'en';
    //     when(mockRepository.isLanguageSupported(newLanguage)).thenReturn(true);
    //     when(mockRepository.setLanguage(newLanguage))
    //         .thenAnswer((_) async => true);

    //     // Act
    //     final result = await languageProvider.changeLanguage(newLanguage);

    //     // Assert
    //     expect(result, true);
    //     expect(languageProvider.currentLanguage, newLanguage);
    //   });

    //   test('應該拒絕不支援的語言', () async {
    //     // Arrange
    //     const unsupportedLanguage = 'unsupported';
    //     when(mockRepository.isLanguageSupported(unsupportedLanguage))
    //         .thenReturn(false);

    //     // Act
    //     final result =
    //         await languageProvider.changeLanguage(unsupportedLanguage);

    //     // Assert
    //     expect(result, false);
    //     expect(languageProvider.error, isNotNull);
    //     expect(languageProvider.error, contains('不支援的語言'));
    //   });

    //   test('應該處理語言設定失敗的情況', () async {
    //     // Arrange
    //     const newLanguage = 'en';
    //     when(mockRepository.isLanguageSupported(newLanguage)).thenReturn(true);
    //     when(mockRepository.setLanguage(newLanguage))
    //         .thenAnswer((_) async => false);

    //     // Act
    //     final result = await languageProvider.changeLanguage(newLanguage);

    //     // Assert
    //     expect(result, false);
    //     expect(languageProvider.error, isNotNull);
    //     expect(languageProvider.error, contains('語言切換失敗'));
    //   });
    // });

    // group('錯誤處理測試', () {
    //   test('應該正確處理異常情況', () async {
    //     // Arrange
    //     const newLanguage = 'en';
    //     when(mockRepository.isLanguageSupported(newLanguage))
    //         .thenThrow(Exception('Repository error'));

    //     // Act
    //     final result = await languageProvider.changeLanguage(newLanguage);

    //     // Assert
    //     expect(result, false);
    //     expect(languageProvider.error, isNotNull);
    //     expect(languageProvider.error, contains('語言切換失敗'));
    //   });
    // });

    // group('狀態管理測試', () {
    //   test('應該在載入時設定正確的狀態', () async {
    //     // Arrange
    //     const newLanguage = 'en';
    //     when(mockRepository.isLanguageSupported(newLanguage)).thenReturn(true);
    //     when(mockRepository.setLanguage(newLanguage)).thenAnswer((_) async {
    //       await Future.delayed(const Duration(milliseconds: 100));
    //       return true;
    //     });

    //     // Act
    //     final future = languageProvider.changeLanguage(newLanguage);

    //     // Assert
    //     expect(languageProvider.isLoading, true);

    //     await future;
    //     expect(languageProvider.isLoading, false);
    //   });

    //   test('應該能夠清除錯誤訊息', () {
    //     // Arrange
    //     languageProvider.changeLanguage('invalid');

    //     // Act
    //     languageProvider.clearError();

    //     // Assert
    //     expect(languageProvider.error, null);
    //   });
    // });
  });
}
