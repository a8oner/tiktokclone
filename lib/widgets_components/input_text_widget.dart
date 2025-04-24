// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData? iconData;
  final String? assetRefrence; //eklenen '?' ile required zorunluluğu kaldırıldı
  final String lableString;
  final bool isObscure;
  final TextInputType? keyboardType;

  const InputTextWidget({
    required this.textEditingController,
    this.iconData,
    this.assetRefrence,
    required this.lableString,
    required this.isObscure,
    this.keyboardType,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: lableString,
        prefixIcon: iconData != null
            ? Icon(iconData)
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  assetRefrence!,
                  width: 10,
                ),
              ),
        labelStyle: const TextStyle(
          fontSize: 18,
        ),
        enabledBorder: OutlineInputBorder(
          //normal görünüm
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          //tıklandığında görünüm
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
