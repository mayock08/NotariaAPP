class UserProfile {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final Address address;
  final String? photoUrl;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.photoUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      photoUrl: json['photoUrl'],
    );
  }
}

class Address {
  final String street;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;

  Address({
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }

  String get fullAddress {
    return '$street, $neighborhood, $city, $state $postalCode';
  }
}
