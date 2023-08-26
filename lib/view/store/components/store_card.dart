import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lalaco/const.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/product.dart';
import 'package:lalaco/model/store.dart';
import 'package:lalaco/view/product_details/product_details_screen.dart';
import 'package:lalaco/view/store_details/store_details_screen.dart';
import 'package:shimmer/shimmer.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoreDetailsScreen(store: store)))
            .then((value) {
          productController.productPerStoreList.clear();
          homeController.getPopularProducts();
        });
      },
      child: Stack(
        children: [
          Material(
            elevation: 8,
            shadowColor: Colors.grey.shade300,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 5,
                    child: Center(
                      child: Hero(
                        tag: store,
                        child: CachedNetworkImage(
                          imageUrl: '$baseUrl/storage/uploads/${store.image}',
                          placeholder: (context, url) => Shimmer.fromColors(
                            highlightColor: Colors.white,
                            baseColor: Colors.grey.shade300,
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.grey.shade300,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          store.store_name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -5,
            right: -5,
            child: Visibility(
              visible: authController.user.value?.user_type == 'Admin',
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 28,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Delete'),
                        content: const Text(
                            'Are you sure you want to delete this store?'),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              authController.deleteUser(store.user_id);
                              storeController.deleteStore(store.id);
                              productController.deleteProductsPerStore(store.id);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
