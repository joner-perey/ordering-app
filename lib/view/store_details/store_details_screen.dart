import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/schedule.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/home/components/popular_product/popular_product.dart';
import 'package:lalaco/view/home/components/popular_product/popular_product_loading.dart';
import 'package:lalaco/view/home/components/section_title.dart';
import 'package:lalaco/view/product/product_screen.dart';
import 'package:lalaco/view/product_details/compnents/product_carousel_slider.dart';
import 'package:lalaco/view/store_details/components/store_carousel_slider.dart';
import 'package:lalaco/view/subscription/subscription_screen.dart';

import '../select_location/view_location.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Store store;

  const StoreDetailsScreen({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final ExpansionTileController controller = ExpansionTileController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await productController.getProductsPerStore(store_id: widget.store.id);
      setState(() {});
    });
    super.initState();
  }

  String getStrScheduleNow() {
    var scheduleNow = widget.store.getScheduleNow();

    if (scheduleNow == null) {
      return '';
    }

    var endTime = scheduleNow.getEndTime();

    return 'Now Open until ${endTime.format(context)}';
  }

  @override
  Widget build(BuildContext context) {
    var scheduleNow = widget.store.getScheduleNow();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoreCarouselSlider(store: widget.store),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.store.store_name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubscriptionScreen(storeId: widget.store.id)));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54
                        ),
                        child: Text('${widget.store.subscription_count} Subscribers')),
                    SizedBox(width: 8,),
                    Visibility(
                      visible: authController.user.value!.user_type == 'Customer',
                      child: ElevatedButton(onPressed: () {
                        if (widget.store.is_user_subscribed == 1) {
                          subscriptionController.deleteSubscription(user_id: authController.user.value!.id, store_id: widget.store.id.toString()).then((value) {

                            setState(() {
                              widget.store.is_user_subscribed = 0;
                              widget.store.subscription_count -= 1;
                            });
                          });
                        } else {
                          subscriptionController.addSubscription(user_id: authController.user.value!.id, store_id: widget.store.id.toString()).then((value) {

                            setState(() {
                              widget.store.is_user_subscribed = 1;
                              widget.store.subscription_count += 1;
                            });
                          });
                        }


                      },
                        child: Text(widget.store.is_user_subscribed == 1 ? 'Subscribed' : 'Subscribe'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.store.is_user_subscribed != 1 ? Colors.deepPurpleAccent : Colors.white,
                          foregroundColor: widget.store.is_user_subscribed != 1 ? Colors.white : Colors.black54
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'About this store:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.store.store_description,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 8),
                    scheduleNow == null
                        ? const Text(
                      'Closed Now',
                      style: TextStyle(color: Colors.red),
                    )
                        : Text(getStrScheduleNow())
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(width: 8),
                        scheduleNow == null
                            ? const Text(
                          'Closed Now',
                          style: TextStyle(color: Colors.red),
                        )
                            : Text(widget.store
                            .getScheduleNow()!
                            .location_description)
                      ],
                    ),
                    Visibility(
                      visible: scheduleNow != null,
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewLocationPage(
                                              location: LatLng(
                                                  double.parse(
                                                      scheduleNow!.latitude),
                                                  double.parse(
                                                      scheduleNow!.longitude)),
                                            )));
                              },
                              child: const Text(
                                'View Location',
                                style: TextStyle(color: Colors.orangeAccent),
                              )),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.orangeAccent,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ExpansionTile(
                controller: controller,
                title: const Text('View Schedule'),
                children: [
                  widget.store.getScheduleNow() == null
                      ? Text('Closed Now')
                      : ListTile(
                    title: Text(
                        'Now Open - ${scheduleNow!.location_description}'),
                    subtitle: Text(
                        ' ${scheduleNow.getStartTime().format(
                            context)} - ${scheduleNow.getEndTime().format(
                            context)}'),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewLocationPage(
                                        location: LatLng(
                                            double.parse(
                                                scheduleNow!.latitude),
                                            double.parse(
                                                scheduleNow!.longitude)),
                                      )));
                        },
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.orangeAccent,
                        )),
                  ),
                  Divider(height: 1),
                  ...List<Widget>.generate(widget.store.schedules.length,
                          (index) {
                        var schedule = widget.store.schedules[index];
                        return ListTile(
                          title: Text(schedule.location_description),
                          subtitle: Text(
                              '${schedule.formatDays()} ${schedule
                                  .getStartTime().format(context)} - ${schedule
                                  .getEndTime().format(context)}'),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewLocationPage(
                                              location: LatLng(
                                                  double.parse(
                                                      schedule.latitude),
                                                  double.parse(
                                                      schedule.longitude)),
                                            )));
                              },
                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.orangeAccent,
                              )),
                        );
                      })
                ],
              ),

              const SectionTitle(
                title: "Store Products",
                page: ProductScreen(),
              ),
              Obx(() {
                if (productController.productPerStoreList.isNotEmpty) {
                  return PopularProduct(
                    popularProducts: productController.productPerStoreList,
                    // popularProducts: homeController.popularProductList,
                  );
                } else {
                  return const PopularProductLoading();
                }
              }),
              const SectionTitle(
                title: "Store Rating",
                page: ProductScreen(),
              ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  RatingBarIndicator(
                    rating: 3,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 35,
                    itemBuilder: (context, index) =>
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                  ),
                  SizedBox(width: 8), // Adjust the width as needed
                  Text(
                    '3.0', // Replace with your rating value
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ),


              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
