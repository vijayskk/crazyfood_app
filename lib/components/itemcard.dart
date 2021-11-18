import 'package:cached_network_image/cached_network_image.dart';
import 'package:crazyfood_app/pages/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Map data;
  final String name;
  final String image;
  final String price;
  const ItemCard(
      {Key? key,
      required this.name,
      required this.price,
      required this.image,
      required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ScreenDetails(
                  data: data,
                )));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: image,
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.contain,
                placeholder: (context, url) => const SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: Center(child: CupertinoActivityIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Text(
                    "₹$price",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
