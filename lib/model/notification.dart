class NotificationModel {
  final String id;
  final String type;
  final dynamic data;
  final String? read_at;
  final String created_at;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.data,
    required this.read_at,
    required this.created_at,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      data: json['data'],
      read_at: json['read_at'],
      created_at: json['created_at'],
    );
  }
}
