import 'package:flutter_test/flutter_test.dart';
import 'package:lead_generation_flutter_app/store/form_store/form_store.dart';

void main() {
  group('FormStore Login Error Tests', () {
    late FormStore formStore;

    setUp(() {
      formStore = FormStore();
    });

    test('should set error message correctly', () {
      // Arrange
      const errorMessage = 'Credenziali non valide';

      // Act
      formStore.setError(errorMessage);

      // Assert
      expect(formStore.hasError, true);
      expect(formStore.errorMessage, errorMessage);
    });

    test('should clear error message correctly', () {
      // Arrange
      formStore.setError('Some error');

      // Act
      formStore.clearError();

      // Assert
      expect(formStore.hasError, false);
      expect(formStore.errorMessage, null);
    });

    test('should validate login correctly with empty credentials', () {
      // Arrange
      formStore.setEmail('');
      formStore.setPassword('');

      // Act
      formStore.loginAction();

      // Assert
      expect(formStore.isValid, false);
    });

    test('should validate login correctly with valid credentials', () {
      // Arrange
      formStore.setEmail('test@example.com');
      formStore.setPassword('password123');

      // Act
      formStore.loginAction();

      // Assert
      expect(formStore.isValid, true);
    });
  });
}
