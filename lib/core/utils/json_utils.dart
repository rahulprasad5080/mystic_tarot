/// Utility methods for safe JSON parsing across all API data models.
/// Prevents runtime type errors (e.g. type `List<dynamic>` is not a subtype of type `String?`).
class JsonUtils {
  /// Converts any JSON value (String, List, Map, num, bool) safely into a String?.
  /// Null values return null.
  /// Lists are joined using [joiner] (defaults to '\n\n').
  /// Maps have their non-empty values joined.
  static String? parseString(dynamic val, {String joiner = '\n\n'}) {
    if (val == null) return null;
    if (val is String) return val;
    if (val is List) {
      final joined = val
          .map((e) => parseString(e, joiner: joiner) ?? '')
          .where((s) => s.isNotEmpty)
          .join(joiner);
      return joined.isNotEmpty ? joined : null;
    }
    if (val is Map) {
      final joined = val.values
          .map((e) => parseString(e, joiner: joiner) ?? '')
          .where((s) => s.isNotEmpty)
          .join(joiner);
      return joined.isNotEmpty ? joined : null;
    }
    return val.toString();
  }

  /// Safely extracts a `Map<String, dynamic>` from a dynamic JSON value.
  /// If the value is a Map, returns a typed copy. Otherwise returns an empty Map.
  static Map<String, dynamic> parseMap(dynamic val) {
    if (val is Map<String, dynamic>) return val;
    if (val is Map) return Map<String, dynamic>.from(val);
    return {};
  }
}
