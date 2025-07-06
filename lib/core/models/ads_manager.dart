// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdsManagerModel {
  final int? id;
  final String uid;
  final DateTime createdAt;
  final String clientId;
  final String clientSecret;
  final String code;
  final String redirectUri;
  final String grantType;
  final String accessToken;
  final String? refreshToken;
  final int? expiresIn;

  AdsManagerModel({
    required this.clientId,
    required this.clientSecret,
    required this.code,
    required this.redirectUri,
    required this.grantType,
    required this.accessToken,
    required this.uid,
    required this.createdAt,
    this.id,
    this.refreshToken,
    this.expiresIn,
  });

  factory AdsManagerModel.fromJson(Map<String, dynamic> json) {
    return AdsManagerModel(
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
      code: json['code'] as String,
      redirectUri: json['redirect_uri'] as String,
      grantType: json['grant_type'] as String,
      accessToken: json['access_token'] as String,
      uid: json['UID'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as int?,
      refreshToken: json['refresh_token'] as String?,
      expiresIn: json['expires_in'] as int?,
    );
  }

  AdsManagerModel copyWith({
    int? id,
    String? uid,
    DateTime? createdAt,
    String? clientId,
    String? organizationId,
    String? clientSecret,
    String? code,
    String? redirectUri,
    String? accessToken,
    String? grantType,
    String? refreshToken,
    int? expiresIn,
  }) {
    return AdsManagerModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      code: code ?? this.code,
      redirectUri: redirectUri ?? this.redirectUri,
      accessToken: accessToken ?? this.accessToken,
      uid: uid ?? this.uid,
      grantType: grantType ?? this.grantType,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'client_secret': clientSecret,
      'code': code,
      'redirect_uri': redirectUri,
      'grant_type': grantType,
      'id': id,
      'UID': uid,
      'created_at': createdAt.toIso8601String(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }

  @override
  String toString() {
    return 'AdsManagerModel(id: $id, uid: $uid, createdAt: $createdAt, '
        'clientId: $clientId, clientSecret: $clientSecret, code: $code, redirectUri: $redirectUri, '
        'grantType: $grantType, accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdsManagerModel &&
        other.id == id &&
        other.uid == uid &&
        other.createdAt == createdAt &&
        other.clientId == clientId &&
        other.clientSecret == clientSecret &&
        other.code == code &&
        other.redirectUri == redirectUri &&
        other.grantType == grantType &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.expiresIn == expiresIn;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      uid,
      createdAt,
      clientId,
      clientSecret,
      code,
      redirectUri,
      grantType,
      accessToken,
      refreshToken,
      expiresIn,
    );
  }
}
