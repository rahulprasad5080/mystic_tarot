import '../../core/utils/json_utils.dart';

/// Generic wrapper for DivineAPI responses.
/// The API always returns HTTP 200 — success is indicated by the `success` field.
class ApiResponse<T> {
  final int success;
  final T? data;
  final String? message;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  bool get isSuccess => success == 1;
  bool get isAuthError => success == 3;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawSuccess = json['success'];
    final int parsedSuccess = rawSuccess is int
        ? rawSuccess
        : (rawSuccess is num
            ? rawSuccess.toInt()
            : (int.tryParse(rawSuccess?.toString() ?? '') ?? 0));

    final rawData = json['data'];
    final Map<String, dynamic> dataMap = rawData is Map
        ? JsonUtils.parseMap(rawData)
        : (rawData is List ? {'result': rawData, ...json} : json);

    return ApiResponse<T>(
      success: parsedSuccess,
      data: rawData != null ? fromJsonT(dataMap) : null,
      message: JsonUtils.parseString(json['msg'] ?? json['message']),
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(
      success: 0,
      message: message,
    );
  }
}
