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
    return ApiResponse<T>(
      success: json['success'] as int? ?? 0,
      data: json['data'] != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      message: json['msg'] as String?,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(
      success: 0,
      message: message,
    );
  }
}
