class AdAccount {
  final String id;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String name;
  final String type;
  final String status;
  final String organizationId;
  final List<String> fundingSourceIds;
  final String currency;
  final String timezone;
  final String advertiser;

  AdAccount({
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.name,
    required this.type,
    required this.status,
    required this.organizationId,
    required this.fundingSourceIds,
    required this.currency,
    required this.timezone,
    required this.advertiser,
  });

  factory AdAccount.fromJson(Map<String, dynamic> json) {
    return AdAccount(
      id: json['id'] ?? '',
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      organizationId: json['organization_id'] ?? '',
      fundingSourceIds: List<String>.from(json['funding_source_ids'] ?? []),
      currency: json['currency'] ?? '',
      timezone: json['timezone'] ?? '',
      advertiser: json['advertiser'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'type': type,
      'status': status,
      'organization_id': organizationId,
      'funding_source_ids': fundingSourceIds,
      'currency': currency,
      'timezone': timezone,
      'advertiser': advertiser,
    };
  }

  AdAccount copyWith({
    String? id,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? name,
    String? type,
    String? status,
    String? organizationId,
    List<String>? fundingSourceIds,
    String? currency,
    String? timezone,
    String? advertiser,
  }) {
    return AdAccount(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      organizationId: organizationId ?? this.organizationId,
      fundingSourceIds: fundingSourceIds ?? this.fundingSourceIds,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      advertiser: advertiser ?? this.advertiser,
    );
  }
}
