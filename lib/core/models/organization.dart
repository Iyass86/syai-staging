class Organization {
  final String id;
  final String updatedAt;
  final String createdAt;
  final String name;
  final String addressLine1;
  final String locality;
  final String administrativeDistrictLevel1;
  final String country;
  final String postalCode;
  final String type;

  Organization({
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.name,
    required this.addressLine1,
    required this.locality,
    required this.administrativeDistrictLevel1,
    required this.country,
    required this.postalCode,
    required this.type,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      name: json['name'] ?? '',
      addressLine1: json['address_line_1'] ?? '',
      locality: json['locality'] ?? '',
      administrativeDistrictLevel1:
          json['administrative_district_level_1'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'name': name,
      'address_line_1': addressLine1,
      'locality': locality,
      'administrative_district_level_1': administrativeDistrictLevel1,
      'country': country,
      'postal_code': postalCode,
      'type': type,
    };
  }

  String get fullAddress {
    return '$addressLine1, $locality, $administrativeDistrictLevel1 $postalCode, $country';
  }
}

class OrganizationsResponse {
  final String requestStatus;
  final String requestId;
  final List<OrganizationWrapper> organizations;

  OrganizationsResponse({
    required this.requestStatus,
    required this.requestId,
    required this.organizations,
  });

  factory OrganizationsResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationsResponse(
      requestStatus: json['request_status'] ?? '',
      requestId: json['request_id'] ?? '',
      organizations: (json['organizations'] as List<dynamic>?)
              ?.map((org) => OrganizationWrapper.fromJson(org))
              .toList() ??
          [],
    );
  }
}

class OrganizationWrapper {
  final String subRequestStatus;
  final Organization organization;

  OrganizationWrapper({
    required this.subRequestStatus,
    required this.organization,
  });

  factory OrganizationWrapper.fromJson(Map<String, dynamic> json) {
    return OrganizationWrapper(
      subRequestStatus: json['sub_request_status'] ?? '',
      organization: Organization.fromJson(json['organization'] ?? {}),
    );
  }
}
