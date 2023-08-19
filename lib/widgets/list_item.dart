import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/controller/place_controller.dart';

class ListItems extends StatelessWidget {
  const ListItems({
    super.key,
    required this.controller,
  });
  final PlaceController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding:
            const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
        itemCount: controller.filterList.length,
        itemBuilder: (_, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.filterList[index].name,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              controller.filterList[index].vicinity,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              controller.formatDistance(controller.calculateDistance(
                controller.filterList[index].geometry.location.lat,
                controller.filterList[index].geometry.location.lng,
                controller.latitude.value,
                controller.longitude.value,
              )),
              style: const TextStyle(color: Colors.white),
            ),
            const Divider(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
