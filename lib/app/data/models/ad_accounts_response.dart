import 'package:flutter_oauth_chat/app/data/models/ad_account.dart';

class AdAccountItem {
  final String subRequestStatus;
  final AdAccount adAccount;

  AdAccountItem({
    required this.subRequestStatus,
    required this.adAccount,
  });

  factory AdAccountItem.fromJson(Map<String, dynamic> json) {
    return AdAccountItem(
      subRequestStatus: json['sub_request_status'] ?? '',
      adAccount: AdAccount.fromJson(json['adaccount'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_request_status': subRequestStatus,
      'adaccount': adAccount.toJson(),
    };
  }
}

class AdAccountsResponse {
  final String requestStatus;
  final String requestId;
  final List<AdAccountItem> adAccounts;

  AdAccountsResponse({
    required this.requestStatus,
    required this.requestId,
    required this.adAccounts,
  });

  factory AdAccountsResponse.fromJson(Map<String, dynamic> json) {
    return AdAccountsResponse(
      requestStatus: json['request_status'] ?? '',
      requestId: json['request_id'] ?? '',
      adAccounts: (json['adaccounts'] as List<dynamic>?)
              ?.map((item) => AdAccountItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_status': requestStatus,
      'request_id': requestId,
      'adaccounts': adAccounts.map((item) => item.toJson()).toList(),
    };
  }

  AdAccountsResponse copyWith({
    String? requestStatus,
    String? requestId,
    List<AdAccountItem>? adAccounts,
  }) {
    return AdAccountsResponse(
      requestStatus: requestStatus ?? this.requestStatus,
      requestId: requestId ?? this.requestId,
      adAccounts: adAccounts ?? this.adAccounts,
    );
  }
}
