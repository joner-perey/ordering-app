class Rating {
  final int id;
  final String store_id;
  final String user_id;
  final String comment;
  final int rate;

  const Rating({
    required this.id,
    required this.store_id,
    required this.user_id,
    required this.comment,
    required this.rate,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      store_id: json['store_id'].toString(),
      user_id: json['user_id'].toString(),
      comment: json['comment'],
      rate: json['rate'],
    );
  }
}
