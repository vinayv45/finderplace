import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/controller/place_controller.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({
    super.key,
    required this.controller,
  });
  final PlaceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 55,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        onChanged: (name) {
          controller.searchPlaceName(name);
        },
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.white),
          hintText: 'Search Text',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        controller: controller.searchController.value,
      ),
    );
  }
}
