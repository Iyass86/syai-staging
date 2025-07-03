import 'dart:convert';

import 'package:flutter_oauth_chat/app/data/models/ad_account.dart';
import 'package:flutter_oauth_chat/app/data/models/organization.dart';

class ChatMessage {
  final int? id;
  final String? sessionId;
  final Message? message;
  final DateTime? createdAt;
  final String? adAccountId;
  final String? organizationId;
  ChatMessage({
    this.id,
    this.sessionId,
    this.message,
    this.createdAt,
    this.adAccountId,
    this.organizationId,
  });

  factory ChatMessage.fromRawJson(String str) =>
      ChatMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        sessionId: json["session_id"],
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        adAccountId: json["ad_account_id"],
        organizationId: json["organization_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "session_id": sessionId,
        "message": message?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "ad_account_id": adAccountId,
        "organization_id": organizationId,
      };
}

class Message {
  final String? type;
  final String? content;
  final List<dynamic>? toolCalls;
  final AdditionalKwargs? additionalKwargs;
  final AdditionalKwargs? responseMetadata;
  final List<dynamic>? invalidToolCalls;

  Message({
    this.type,
    this.content,
    this.toolCalls,
    this.additionalKwargs,
    this.responseMetadata,
    this.invalidToolCalls,
  });

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        type: json["type"],
        content: json["content"],
        toolCalls: json["tool_calls"] == null
            ? []
            : List<dynamic>.from(json["tool_calls"]!.map((x) => x)),
        additionalKwargs: json["additional_kwargs"] == null
            ? null
            : AdditionalKwargs.fromJson(json["additional_kwargs"]),
        responseMetadata: json["response_metadata"] == null
            ? null
            : AdditionalKwargs.fromJson(json["response_metadata"]),
        invalidToolCalls: json["invalid_tool_calls"] == null
            ? []
            : List<dynamic>.from(json["invalid_tool_calls"]!.map((x) => x)),
      );

  bool get isFromCurrentUser => type != 'ai';

  Map<String, dynamic> toJson() => {
        "type": type,
        "content": content,
        "tool_calls": toolCalls == null
            ? []
            : List<dynamic>.from(toolCalls!.map((x) => x)),
        "additional_kwargs": additionalKwargs?.toJson(),
        "response_metadata": responseMetadata?.toJson(),
        "invalid_tool_calls": invalidToolCalls == null
            ? []
            : List<dynamic>.from(invalidToolCalls!.map((x) => x)),
      };
}

class AdditionalKwargs {
  AdditionalKwargs();

  factory AdditionalKwargs.fromRawJson(String str) =>
      AdditionalKwargs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdditionalKwargs.fromJson(Map<String, dynamic> json) =>
      AdditionalKwargs();

  Map<String, dynamic> toJson() => {};
}
