import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    orderController.fetchOrderToCustomer(
        user_id: authController.user.value!.id);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: Column(
                children: List<Widget>.generate(
                  orderController.orderList.length,
                  (index) {
                    final order = orderController.orderList[index];
                    final store = order.store.store_name;
                    final type = order.type;
                    final status = order.status;
                    final name = order.user.name;
                    final image = order.user.image;
                    double totalPrice = 0;

                    for (int i = 0; i < order.orderDetails.length; i++) {
                      totalPrice += order.orderDetails[i].price *
                          order.orderDetails[i].quantity;
                    }

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Image.network(
                                    '$baseUrl/storage/uploads/$image',
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
                                      Text(
                                        'Status: $status',
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index !=
                            cartItemsController.cartItemList.length - 1)
                          const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
