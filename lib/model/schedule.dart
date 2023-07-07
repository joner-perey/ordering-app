class Schedule {
  final int id;
  final int store_id;
  final String latitude;
  final String longitude;
  final String start_time;
  final String end_time;
  final String days;
  final String location_description;

  const Schedule({
    required this.id,
    required this.store_id,
    required this.latitude,
    required this.longitude,
    required this.start_time,
    required this.end_time,
    required this.days,
    required this.location_description,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      store_id: json['store_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      start_time: json['start_time'],
      end_time: json['end_time'],
      days: json['days'],
      location_description: json['location_description'],
    );
  }
}
