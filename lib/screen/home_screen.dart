import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:taskapp/controller/place_controller.dart';
import 'package:taskapp/widgets/list_item.dart';
import 'package:taskapp/widgets/search_box_widget.dart';
import 'package:taskapp/widgets/tab_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  final placeController = Get.put(PlaceController());
                  placeController.getCurrentLocation();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ))
          ],
          title: const Text(
            'Finder',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
        body: GetBuilder(
          init: PlaceController(),
          builder: (controller) {
            return controller.locationResults.isEmpty
                ? Center(
                    child: Text(
                      controller.errorText.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    children: [
                      TabWidget(
                        controller: controller,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SearchBoxWidget(controller: controller),
                      const SizedBox(
                        height: 20,
                      ),
                      ListItems(controller: controller)
                    ],
                  );
          },
        ));
  }
}
