import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';
import 'package:lalaco/model/ad_banner.dart';

class RemoteBannerService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/banners';

  Future<dynamic> get() async {
    var response = await http.get(Uri.parse(remoteUrl));
    final parsedJson = jsonDecode(response.body);
    final results = parsedJson['banners'];

    List<AdBanner> banners = [];

    if (response.statusCode == 200) {
      for (final result in results) {
        banners.add(AdBanner.fromJson(result));
      }
    } else {
      throw Exception('Failed to load Stores');
    }

    return banners;
  }
}