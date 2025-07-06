class SnapTokenResponse {
  final String? organizationId;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final List<String> scope;

  SnapTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.scope,
    this.organizationId,
  });

  factory SnapTokenResponse.fromJson(Map<String, dynamic> json) {
    return SnapTokenResponse(
      organizationId: json['organization_id'] ?? '',
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      expiresIn: json['expires_in'] ?? 0,
      scope: List<String>.from(json['scope']?.split(' ') ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization_id': organizationId,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'scope': scope.join(' '),
    };
  }

  copyWith({
    String? organizationId,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    List<String>? scope,
  }) {
    return SnapTokenResponse(
      organizationId: organizationId ?? this.organizationId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      scope: scope ?? this.scope,
    );
  }
}
