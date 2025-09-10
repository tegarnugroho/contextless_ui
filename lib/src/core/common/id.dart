import 'dart:math';

/// Utility class for generating unique IDs.
class IdUtils {
  static final Random _random = Random();

  /// Generates a UUID v4 string.
  static String generateUuid() {
    final bytes = List<int>.generate(16, (i) => _random.nextInt(256));

    // Version 4 UUID format
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // Version bits
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // Variant bits

    return [
      _bytesToHex(bytes, 0, 4),
      _bytesToHex(bytes, 4, 2),
      _bytesToHex(bytes, 6, 2),
      _bytesToHex(bytes, 8, 2),
      _bytesToHex(bytes, 10, 6),
    ].join('-');
  }

  static String _bytesToHex(List<int> bytes, int start, int length) {
    final buffer = StringBuffer();
    for (int i = start; i < start + length; i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}

/// Convenience function to generate a unique ID
String generateId() => IdUtils.generateUuid();
