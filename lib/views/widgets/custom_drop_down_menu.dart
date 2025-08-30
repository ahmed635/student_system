import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../config/app_colors.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  List<T>? items;
  String? hintText;
  ValueChanged<T?>? onChanged;
  bool? enabled;
  T? selectedItem;
  bool Function(T, T)? compareFn;

  CustomDropdownMenu({
    super.key,
    this.hintText,
    this.items,
    this.onChanged,
    this.enabled,
    this.selectedItem,
    this.compareFn,
  });

  @override
  State<CustomDropdownMenu<T>> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T> extends State<CustomDropdownMenu<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      enabled: widget.enabled ?? true,
      onChanged: widget.onChanged,
      compareFn: widget.compareFn,
      selectedItem: widget.selectedItem,
      itemAsString: (item) => translate(item.toString()),
      items: (filter, infiniteScrollProps) => widget.items ?? [],
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.hintText,
          hintStyle:
              TextStyle(color: AppColors.grey, fontWeight: FontWeight.w500),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.grey,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.grey,
              width: 1,
            ),
          ),
        ),
      ),
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.grey,
          ),
          iconOpened: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
          ),
        ),
      ),
      popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          constraints: BoxConstraints(),
          containerBuilder: (context, popupWidget) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white, // Change this to your desired color
                borderRadius:
                    BorderRadius.circular(8), // Optional: Add border radius
              ),
              child: popupWidget,
            );
          }),
    );
  }
}
