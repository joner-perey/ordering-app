import 'package:get/get.dart';
import 'package:lalaco/route/app_route.dart';
import 'package:lalaco/view/dashboard/dashboard_screen.dart';
import 'package:lalaco/view/dashboard/dashboard_binding.dart';

class AppPage {
  static var list = [
    GetPage(
        name: AppRoute.dashboard,
        page: () => const DashboardScreen(),
        binding: DashboardBinding(),
    )
  ];
}
