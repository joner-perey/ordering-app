import 'package:flutter/material.dart';

class InputDropdownButton<T> extends StatelessWidget {
  final T? value;
  final String title;
  final List<T> items;
  final Function(T?)? onChanged;
  final double? width;
  final double? height;
  final String Function(T)? itemToString;
  final String? Function(T?)? validation; // Added validation property

  const InputDropdownButton({
    Key? key,
    required this.title,
    required this.items,
    this.value,
    this.onChanged,
    this.width,
    this.height,
    this.itemToString,
    this.validation, // Added validation property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DropdownButtonFormField<T>(
        value: value,
        onChanged: onChanged,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemToString != null ? itemToString!(item) : item.toString()),
          );
        }).toList(),
        validator: validation, // Set the validation function
        decoration: InputDecoration(
          hintText: title,
          labelText: title,
          labelStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          hintStyle: const TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(width: 1, color: Colors.black26),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(width: 1, color: Colors.black26),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(width: 1, color: Colors.black26),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(width: 1, color: Colors.black26),
          ),
        ),
      ),
    );
  }
}
