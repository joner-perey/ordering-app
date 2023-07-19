import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/view/order/order_details_screen.dart';
import 'package:lalaco/view/review/rating_screen.dart';

import '../select_location/view_location.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: FutureBuilder(
          future: fetchOrderData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching orders'));
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      child: Column(
                        children: List<Widget>.generate(
                          orderController.orderList.length,
                          (index) {
                            print(orderController.orderList.length);
                            final order = orderController.orderList[index];
                            final store = order.store.store_name;
                            final type = order.type;
                            final name = order.user.name;
                            final image = order.user.image;
                            double totalPrice = 0;
                            for (int i = 0;
                                i < order.orderDetails.length;
                                i++) {
                              totalPrice += order.orderDetails[i].price *
                                  order.orderDetails[i].quantity;
                            }

                            // Create an RxString for observing changes in status
                            final status = RxString(order.status);

                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          image != null ?
                                          Image.network(
                                            '$baseUrl/storage/uploads/$image',
                                            width: 90,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ) : Image.asset(
                                            "assets/user_image.png",
                                            width: 90,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name: $name',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Store: $store',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Type: $type',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              if (authController
                                                      .user.value?.user_type ==
                                                  'Vendor')
                                                Obx(() {
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        'Status: ',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      DropdownButton<String>(
                                                        key: Key(order.id
                                                            .toString()),
                                                        value: status.value,
                                                        items: <DropdownMenuItem<
                                                            String>>[
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: 'Pending',
                                                            child:
                                                                Text('Pending'),
                                                          ),
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: 'Preparing',
                                                            child: Text(
                                                                'Preparing'),
                                                          ),
                                                          if (type ==
                                                              'Delivery')
                                                            DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  'On Delivery',
                                                              child: Text(
                                                                  'On Delivery'),
                                                            )
                                                          else if (type ==
                                                              'Pick-up')
                                                            DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  'For Pickup',
                                                              child: Text(
                                                                  'For Pickup'),
                                                            ),
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: 'Completed',
                                                            child: Text(
                                                                'Completed'),
                                                          ),
                                                        ],
                                                        onChanged:
                                                            (String? newValue) {
                                                          if (newValue !=
                                                              null) {
                                                            // Update the status value
                                                            status.value =
                                                                newValue;
                                                            // Update the order status
                                                            orderController
                                                                .updateOrderStatus(
                                                              id: order.id,
                                                              status: newValue,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                })
                                              else
                                                Text(
                                                  'Status: ${status.value}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Total: Php$totalPrice',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewLocationPage(
                                                                  location: LatLng(
                                                                      double.parse(
                                                                          order.latitude),
                                                                      double.parse(
                                                                          order.longitude)),
                                                                )));
                                                  },
                                                  icon: const Icon(
                                                    Icons.location_on,
                                                    color: Colors.orangeAccent,
                                                  )),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderDetailsScreen(
                                                                  order_id:
                                                                      order.id),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'View Products',
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Visibility(
                                                    visible: status.value ==
                                                            'Completed' &&
                                                        authController
                                                                .user
                                                                .value
                                                                ?.user_type ==
                                                            'Customer',
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                RatingScreen(
                                                              store_id: order
                                                                  .store.id,
                                                              order_id:
                                                                  order.id,
                                                              has_rating: order
                                                                  .has_rating,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        order.has_rating
                                                            ? 'View Reviews'
                                                            : 'Write a Review',
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (index !=
                                    orderController.orderList.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> fetchOrderData() async {
    try {
      if (authController.user.value != null) {
        print(authController.user.value?.user_type);
        if (authController.user.value?.user_type == 'Vendor') {
          await orderController.fetchOrderToVendor(
              store_id: authController.store.value!.id.toString());
        } else {
          await orderController.fetchOrderToCustomer(
              user_id: authController.user.value!.id);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
