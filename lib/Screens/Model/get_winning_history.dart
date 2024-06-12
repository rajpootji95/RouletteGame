class GetWinningHistoryModel {
  GetWinningHistoryModel({
    required this.error,
    required this.message,
    required this.data,
  });

  final bool? error;
  final String? message;
  final List<Datum> data;

  factory GetWinningHistoryModel.fromJson(Map<String, dynamic> json){
    return GetWinningHistoryModel(
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
    required this.winningAmount,
    required this.betNumber,
    required this.betType,
    required this.date,
  });

  final String? id;
  final String? userId;
  final String? winningAmount;
  final String? betNumber;
  final String? betType;
  final DateTime? date;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      userId: json["user_id"],
      winningAmount: json["winning_amount"],
      betNumber: json["bet_number"],
      betType: json["bet_type"],
      date: DateTime.tryParse(json["date"] ?? ""),
    );
  }

}
