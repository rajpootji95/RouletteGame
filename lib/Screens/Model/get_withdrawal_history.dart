class GetWithdrowalResponseModel {
  GetWithdrowalResponseModel({
    required this.error,
    required this.message,
    required this.data,
  });

  final bool? error;
  final String? message;
  final List<Datum> data;

  factory GetWithdrowalResponseModel.fromJson(Map<String, dynamic> json){
    return GetWithdrowalResponseModel(
      error: json["error"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.amount,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.accountHolderName,
    required this.status,
    required this.created,
    required this.updated,
  });

  final String? id;
  final String? userId;
  final String? amount;
  final String? accountNumber;
  final String? ifscCode;
  final String? bankName;
  final String? accountHolderName;
  final String? status;
  final DateTime? created;
  final DateTime? updated;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      userId: json["user_id"],
      amount: json["amount"],
      accountNumber: json["account_number"],
      ifscCode: json["ifsc_code"],
      bankName: json["bank_name"],
      accountHolderName: json["account_holder_name"],
      status: json["status"],
      created: DateTime.tryParse(json["created"] ?? ""),
      updated: DateTime.tryParse(json["updated"] ?? ""),
    );
  }

}
