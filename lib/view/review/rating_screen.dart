import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lalaco/component/input_text_area.dart';
import 'package:lalaco/controller/controllers.dart';
import 'package:lalaco/model/rating.dart';

class RatingScreen extends StatefulWidget {
  final int store_id;
  final int order_id;

  const RatingScreen({Key? key, required this.store_id, required this.order_id})
      : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  TextEditingController ratingTextAreaController = TextEditingController();
  TextEditingController commentTextAreaController = TextEditingController();
  double currentRating = 5.0;

  @override
  void initState() {
    super.initState();
    ratingTextAreaController.text = currentRating.toString();
  }

  @override
  void dispose() {
    ratingTextAreaController.dispose();
    commentTextAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Store Review')),
        body: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Rate: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: currentRating,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 35,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            currentRating = rating;
                            ratingTextAreaController.text =
                                currentRating.toString();
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        currentRating.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InputTextArea(
                          title: 'Write review',
                          textEditingController: commentTextAreaController,
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {
                          ratingController.addRating(
                              store_id: widget.store_id,
                              user_id: int.parse(authController.user.value!.id),
                              comment: commentTextAreaController.text,
                              rate: double.parse(ratingTextAreaController.text),
                              order_id: widget.order_id);
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Rating>>(
              future: ratingController.getRatingByStoreId(
                  store_id: widget.store_id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final ratings = snapshot.data;
                  if (ratings == null || ratings.isEmpty) {
                    return Text('No ratings available.');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ratings.length,
                      itemBuilder: (context, index) {
                        final rating = ratings[index];
                        return ListTile(
                          title: Text('Rating: ${rating.rate}'),
                          subtitle: Text('Comment: ${rating.comment}'),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
