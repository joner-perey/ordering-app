import 'package:hive/hive.dart';
import 'package:lalaco/model/user.dart';

import '../../model/store.dart';

class LocalAuthService {
  Box<String>? _tokenBox;
  Box<User>? _userBox;
  Box<Store>? _storeBox;

  Future<void> init() async {
    _tokenBox = await Hive.openBox<String>('token');
    _userBox = await Hive.openBox<User>('user');
  }

  Future<void> addToken({required String token}) async {
    await _tokenBox?.put('token', token);
  }

  Future<void> addUser({required User user}) async {
    await _userBox?.put('user', user);
  }

  Future<void> addStore({required Store store}) async {
    await _storeBox?.put('store', store);
  }

  Future<void> clear() async {
    await _tokenBox?.clear();
    await _userBox?.clear();
    await _storeBox?.clear();
  }

  String? getToken() => _tokenBox?.get('token');

  User? getUser() => _userBox?.get('user');

  Store? getStore() => _storeBox?.get('store');
}
