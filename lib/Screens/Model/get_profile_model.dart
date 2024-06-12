class GetProfileModel {
  GetProfileModel({
    required this.error,
    required this.message,
    required this.data,
  });

  final bool? error;
  final String? message;
  final List<Datum> data;

  factory GetProfileModel.fromJson(Map<String, dynamic> json){
    return GetProfileModel(
      error: json["error"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.loginId,
    required this.vendorId,
    required this.username,
    required this.email,
    required this.mobile,
    required this.wallet,
    required this.primaryWallet,
    required this.password,
    required this.state,
    required this.city,
    required this.status,
    required this.created,
    required this.updated,
  });

  final String? id;
  final String? loginId;
  final String? vendorId;
  final String? username;
  final String? email;
  final String? mobile;
  final String? wallet;
  final String? primaryWallet;
  final String? password;
  final String? state;
  final String? city;
  final String? status;
  final DateTime? created;
  final DateTime? updated;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      loginId: json["login_id"],
      vendorId: json["vendor_id"],
      username: json["username"],
      email: json["email"],
      mobile: json["mobile"],
      wallet: json["wallet"],
      primaryWallet: json["primary_wallet"],
      password: json["password"],
      state: json["state"],
      city: json["city"],
      status: json["status"],
      created: DateTime.tryParse(json["created"] ?? ""),
      updated: DateTime.tryParse(json["updated"] ?? ""),
    );
  }

}
