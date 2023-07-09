import 'package:flutter/material.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int order_id;

  const OrderDetailsScreen({Key? key, required this.order_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchOrderDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Order Products'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Order Products'),
            ),
            body: Center(child: Text('Error fetching order details')),
          );
        } else {
          return buildOrderDetailsScreen();
        }
      },
    );
  }

  Future<void> fetchOrderDetails() async {
    try {
      await orderDetailController.fetchOrderToCustomer(order_id: order_id);
    } catch (e) {
      // Handle error here
      print(e.toString());
    }
  }

  Scaffold buildOrderDetailsScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Products'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: Column(
                children: List<Widget>.generate(
                  orderDetailController.orderDetailList.length,
                  (index) {
                    final orderDetails =
                        orderDetailController.orderDetailList[index];
                    final productName = orderDetails.product.name;
                    final productImage = orderDetails.product.image;
                    final quantity = orderDetails.quantity;
                    final price = orderDetails.price;
                    final total = price * quantity;

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
                                    '$baseUrl/storage/uploads/$productImage',
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
                                        'Name: $productName',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Price: $price',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Quantity: $quantity',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Total: $total',
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
