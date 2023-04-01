import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../misc/app_colors.dart';

class MultiSelectDdl {
  Map<String, String> items = {};
  List<MultiSelectItem> dropDownData = [];
  int count = 0;
  final Function onConfirm, setStateFunction;
  final String title;
  final List<String> selectedValues;
  MultiSelectDdl({required this.selectedValues, required this.setStateFunction, required this.onConfirm, required this.title, required this.items});

  Widget multiSelectDdl () {
    List<MultiSelectItem> dropDownData = [MultiSelectItem("all", "Select All")];

    items.forEach((key, value) {
      dropDownData.add(MultiSelectItem(key, value));
    });

    return MultiSelectDialogField(
      items: dropDownData,
      initialValue: selectedValues,
      selectedColor: AppColors.facebookColor,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: AppColors.baseGrey30Color,
          width: 2,
        ),
      ),
      buttonIcon: const Icon(
        Icons.arrow_drop_down,
        color: AppColors.facebookColor,
      ),
      buttonText: Text(
        "Select $title",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if(value == null || value.isEmpty) {
          if (kDebugMode) {
            print("Please select at least one option");
          }
        }
        return null;
      },
      searchable: true,
      searchIcon: const Icon(Icons.search),
      onSelectionChanged: (keys) {
        setStateFunction(keys);
      },
      onConfirm: (results) { onConfirm(results); },
    );

  }

}