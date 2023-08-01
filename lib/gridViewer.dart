import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';


class GridViewer extends StatefulWidget {
  const GridViewer({super.key});

  @override
  State<GridViewer> createState() => _GridViewState();
}

class _GridViewState extends State<GridViewer> {
  final List<Map<String, dynamic>> GridMap = [
    {
      "title": "title",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/48/56/9a/48569af55a92263c82e614ffb233e793.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/35/4c/8f/354c8f19195aa068e45b858582a40177.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/2e/af/e3/2eafe33129c6c8a5c20c573e28f0690d.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/59/3d/c0/593dc085ba0e2a5e3c0f2d994e1a0343.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/3d/fc/c3/3dfcc3f65e5e68a97cb69edae1b60438.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/66/06/5d/66065d350ef478fdd83599374a7493b9.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/f2/84/68/f28468d5672b901a031bb97c4be2d2dc.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/8f/70/2e/8f702edfd00922547f4ce70f4280f1f2.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/5b/ba/ce/5bbacef1aa710ee7ca047e16b8322d5f.jpg",
    },
    {
      "title": "Winter",
      "price": "\$100",
      "images": "https://i.pinimg.com/564x/b2/1c/f1/b21cf1e5d1ec6344ffdf1b7f6bd49688.jpg",
    }
  ];

    @override
    Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        mainAxisExtent: 290,
      ),
      itemCount: GridMap.length,
      itemBuilder: (_, index) {
        return Container( 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.lightBlue.shade200,
          ),
          child: Column(
            children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.network(
                "${GridMap.elementAt(index)['images']}",
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${GridMap.elementAt(index)['title']}",
                    style: Theme.of(context).textTheme.titleLarge!.merge(
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                  Text(
                    "${GridMap.elementAt(index)['price']}",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                      const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.heart,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.cart,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}

