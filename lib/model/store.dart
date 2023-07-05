class Store {
  final int id;
  final String store_name;
  final String store_description;
  final String image;
  final String location_description;
  final String longitude;
  final String latitude;

  const Store({
    required this.id,
    required this.store_name,
    required this.store_description,
    required this.image,
    required this.location_description,
    required this.longitude,
    required this.latitude,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        id: json['id'],
        store_name: json['store_name'],
        image: json['image'],
        store_description: json['store_description'],
        location_description: json['location_description'],
        longitude: json['longitude'],
        latitude: json['latitude']
    );
  }

  @override
  String toString() {
    return this.store_name;
  }

}