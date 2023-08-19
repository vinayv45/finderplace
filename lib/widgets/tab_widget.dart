import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/controller/place_controller.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({
    super.key,
    required this.controller,
  });
  final PlaceController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.types.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              controller.tabString.value = controller.types[index];
              controller.typesList(controller.tabString.value);
              controller.update();
            },
            child: Container(
              decoration: BoxDecoration(
                color: controller.tabString.value == controller.types[index]
                    ? Colors.green
                    : Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    controller.types[index].replaceAll("_", " ").capitalize!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
