class Pixel {
  final String id;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String effectiveStatus;
  final String name;
  final String adAccountId;
  final String status;
  final String pixelJavascript;

  Pixel({
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.effectiveStatus,
    required this.name,
    required this.adAccountId,
    required this.status,
    required this.pixelJavascript,
  });

  factory Pixel.fromJson(Map<String, dynamic> json) {
    return Pixel(
      id: json['id'] ?? '',
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      effectiveStatus: json['effective_status'] ?? '',
      name: json['name'] ?? '',
      adAccountId: json['ad_account_id'] ?? '',
      status: json['status'] ?? '',
      pixelJavascript: json['pixel_javascript'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'effective_status': effectiveStatus,
      'name': name,
      'ad_account_id': adAccountId,
      'status': status,
      'pixel_javascript': pixelJavascript,
    };
  }

  bool get isActive => status == 'ACTIVE' && effectiveStatus == 'ACTIVE';

  Pixel copyWith({
    String? id,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? effectiveStatus,
    String? name,
    String? adAccountId,
    String? status,
    String? pixelJavascript,
  }) {
    return Pixel(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      effectiveStatus: effectiveStatus ?? this.effectiveStatus,
      name: name ?? this.name,
      adAccountId: adAccountId ?? this.adAccountId,
      status: status ?? this.status,
      pixelJavascript: pixelJavascript ?? this.pixelJavascript,
    );
  }
}

class PixelItem {
  final String subRequestStatus;
  final Pixel pixel;

  PixelItem({
    required this.subRequestStatus,
    required this.pixel,
  });

  factory PixelItem.fromJson(Map<String, dynamic> json) {
    return PixelItem(
      subRequestStatus: json['sub_request_status'] ?? '',
      pixel: Pixel.fromJson(json['pixel'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_request_status': subRequestStatus,
      'pixel': pixel.toJson(),
    };
  }
}

class PixelsResponse {
  final String requestStatus;
  final String requestId;
  final List<PixelItem> pixels;

  PixelsResponse({
    required this.requestStatus,
    required this.requestId,
    required this.pixels,
  });

  factory PixelsResponse.fromJson(Map<String, dynamic> json) {
    return PixelsResponse(
      requestStatus: json['request_status'] ?? '',
      requestId: json['request_id'] ?? '',
      pixels: (json['pixels'] as List<dynamic>?)
              ?.map((item) => PixelItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_status': requestStatus,
      'request_id': requestId,
      'pixels': pixels.map((item) => item.toJson()).toList(),
    };
  }

  PixelsResponse copyWith({
    String? requestStatus,
    String? requestId,
    List<PixelItem>? pixels,
  }) {
    return PixelsResponse(
      requestStatus: requestStatus ?? this.requestStatus,
      requestId: requestId ?? this.requestId,
      pixels: pixels ?? this.pixels,
    );
  }
}
