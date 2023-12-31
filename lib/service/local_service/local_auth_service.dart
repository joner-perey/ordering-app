import 'package:hive/hive.dart';
import 'package:lalaco/model/user.dart';

import '../../model/store.dart';

class LocalAuthService {
  Box<String>? _tokenBox;
  Box<int>? _userIdBox;
  Box<int>? _walkThrough;
  Box<User>? _userBox;
  Box<Store>? _storeBox;

  Future<void> init() async {
    _tokenBox = await Hive.openBox<String>('token');
    _userIdBox = await Hive.openBox<int>('user_id');
    _walkThrough = await Hive.openBox<int>('walk_through');
    // _userBox = await Hive.openBox<User>('user');
  }

  Future<void> addToken({required String token}) async {
    await _tokenBox?.put('token', token);
  }

  Future<void> addUserId({required int userId}) async {
    await _userIdBox?.put('user_id', userId);
  }

  Future<void> addUser({required User user}) async {
    await _userBox?.put('user', user);
  }

  Future<void> addStore({required Store store}) async {
    await _storeBox?.put('store', store);
  }

  Future<void> updateWalkThrough({required int walkThrough}) async {
    print('walk_through updated');
    await _walkThrough?.put('walk_through', walkThrough);
  }

  Future<void> clear() async {
    await _tokenBox?.clear();
    await _userIdBox?.clear();
    await _userBox?.clear();
    await _storeBox?.clear();
    await _walkThrough?.clear();
  }

  String? getToken() => _tokenBox?.get('token');

  int? getUserId() => _userIdBox?.get('user_id');

  User? getUser() => _userBox?.get('user');

  Store? getStore() => _storeBox?.get('store');

  int? getWalkThrough() => _walkThrough?.get('walk_through');
}
