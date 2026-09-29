import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ecommerce_app/consts/validator.dart';

void main() {
  group('MyValidators', () {
    // ── displayNameValidator ──────────────────────────────────────────────
    group('displayNameValidator', () {
      test('returns error for empty name', () {
        expect(MyValidators.displayNamevalidator(''), isNotNull);
      });
      test('returns error for null', () {
        expect(MyValidators.displayNamevalidator(null), isNotNull);
      });
      test('returns error for name shorter than 3 chars', () {
        expect(MyValidators.displayNamevalidator('ab'), isNotNull);
      });
      test('returns error for name longer than 20 chars', () {
        expect(MyValidators.displayNamevalidator('abcdefghijklmnopqrstu'), isNotNull);
      });
      test('returns null for valid 3-char name', () {
        expect(MyValidators.displayNamevalidator('Ali'), isNull);
      });
      test('returns null for valid 20-char name', () {
        expect(MyValidators.displayNamevalidator('A' * 20), isNull);
      });
    });

    // ── emailValidator ────────────────────────────────────────────────────
    group('emailValidator', () {
      test('returns error for empty email', () {
        expect(MyValidators.emailValidator(''), isNotNull);
      });
      test('returns error for null', () {
        expect(MyValidators.emailValidator(null), isNotNull);
      });
      test('returns error for invalid email (no @)', () {
        expect(MyValidators.emailValidator('notanemail'), isNotNull);
      });
      test('returns error for email without domain', () {
        expect(MyValidators.emailValidator('user@'), isNotNull);
      });
      test('returns null for valid email', () {
        expect(MyValidators.emailValidator('user@example.com'), isNull);
      });
      test('returns null for email with subdomains', () {
        expect(MyValidators.emailValidator('user@mail.example.co.uk'), isNull);
      });
    });

    // ── passwordValidator ──────────────────────────────────────────────────
    group('passwordValidator', () {
      test('returns error for empty password', () {
        expect(MyValidators.passwordValidator(''), isNotNull);
      });
      test('returns error for null', () {
        expect(MyValidators.passwordValidator(null), isNotNull);
      });
      test('returns error for password shorter than 6 chars', () {
        expect(MyValidators.passwordValidator('abc'), isNotNull);
      });
      test('returns null for 6-char password', () {
        expect(MyValidators.passwordValidator('abc123'), isNull);
      });
      test('returns null for long password', () {
        expect(MyValidators.passwordValidator('supersecurepassword123!'), isNull);
      });
    });

    // ── repeatPasswordValidator ────────────────────────────────────────────
    group('repeatPasswordValidator', () {
      test('returns error when passwords do not match', () {
        expect(
          MyValidators.repeatPasswordValidator(value: 'abc', password: 'xyz'),
          isNotNull,
        );
      });
      test('returns null when passwords match', () {
        expect(
          MyValidators.repeatPasswordValidator(
              value: 'abc123', password: 'abc123'),
          isNull,
        );
      });
    });

    // ── priceValidator ────────────────────────────────────────────────────
    group('priceValidator', () {
      test('returns error for empty price', () {
        expect(MyValidators.priceValidator(''), isNotNull);
      });
      test('returns error for null', () {
        expect(MyValidators.priceValidator(null), isNotNull);
      });
      test('returns error for non-numeric input', () {
        expect(MyValidators.priceValidator('abc'), isNotNull);
      });
      test('returns error for negative price', () {
        expect(MyValidators.priceValidator('-1'), isNotNull);
      });
      test('returns error for more than 2 decimal places', () {
        expect(MyValidators.priceValidator('10.999'), isNotNull);
      });
      test('returns null for zero price', () {
        expect(MyValidators.priceValidator('0'), isNull);
      });
      test('returns null for integer price', () {
        expect(MyValidators.priceValidator('99'), isNull);
      });
      test('returns null for 2-decimal price', () {
        expect(MyValidators.priceValidator('19.99'), isNull);
      });
    });

    // ── quantityValidator ─────────────────────────────────────────────────
    group('quantityValidator', () {
      test('returns error for empty quantity', () {
        expect(MyValidators.quantityValidator(''), isNotNull);
      });
      test('returns error for null', () {
        expect(MyValidators.quantityValidator(null), isNotNull);
      });
      test('returns error for non-integer input', () {
        expect(MyValidators.quantityValidator('3.5'), isNotNull);
      });
      test('returns error for negative quantity', () {
        expect(MyValidators.quantityValidator('-1'), isNotNull);
      });
      test('returns null for zero quantity', () {
        expect(MyValidators.quantityValidator('0'), isNull);
      });
      test('returns null for positive integer', () {
        expect(MyValidators.quantityValidator('100'), isNull);
      });
    });

    // ── requiredValidator ─────────────────────────────────────────────────
    group('requiredValidator', () {
      test('returns error for empty string', () {
        expect(MyValidators.requiredValidator(''), isNotNull);
      });
      test('returns error for whitespace only', () {
        expect(MyValidators.requiredValidator('   '), isNotNull);
      });
      test('returns null for non-empty string', () {
        expect(MyValidators.requiredValidator('hello'), isNull);
      });
    });
  });
}
