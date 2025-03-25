import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class HelperFunctions {
  /// Extracts JSON from a string and returns it as a Map if found, else null.
  static Map<String, dynamic>? extractJson(String text,
      [String separator = '']) {
    final index = text.indexOf(separator);

    /// If separator is not found, return null
    if (index == -1) return null; // If separator is not found, return null

    final str = text.substring(index + separator.length);

    final startIndex = str.indexOf('{');
    int endIndex = str.lastIndexOf('}');

    if (startIndex == -1 || endIndex == -1 || startIndex > endIndex) {
      return null; // Ensure valid JSON bracket positions
    }

    while (endIndex > startIndex) {
      try {
        final extractedJson = str.substring(startIndex, endIndex + 1);
        return json.decode(extractedJson) as Map<String, dynamic>;
      } on FormatException {
        // Move back to the previous '}'
        endIndex = str.lastIndexOf('}', endIndex - 1);
      }
    }

    return null; // If no valid JSON is found, return null
  }

  /// Parses the response body and returns a JSON map if found, else null.
  static Map<String, dynamic>? getJsonMap(String response) {
    final responseBody = response;
    final document = parser.parse(responseBody);

    final scriptElements = document
        .querySelectorAll('script')
        .map((element) => element.text)
        .toList(growable: false);

    final ytInitialDataScript = scriptElements.firstWhereOrNull(
      (script) =>
          script.contains('var ytInitialData = ') ||
          script.contains('window["ytInitialData"] = '),
    );

    if (ytInitialDataScript != null) {
      return extractJson(ytInitialDataScript);
    }

    return null;
  }

  /// Retries a function up to [maxAttempts] times with a delay between attempts.
  static Future<T> retry<T>(
    FutureOr<T> Function() function, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;

    while (attempt < maxAttempts) {
      try {
        return await function();
      } catch (e) {
        attempt++;
        if (attempt >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay);
      }
    }
    throw Exception('Retry failed after $maxAttempts attempts');
  }
}
