import 'package:lalaco/model/user.dart';

class Subscription {
  final int id;
  final User user;

  const Subscription({
    required this.id,
    required this.user,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    print('subscription');
    return Subscription(
      id: json['id'],
      user: User.fromJson(json['user']),
    );
  }
}
