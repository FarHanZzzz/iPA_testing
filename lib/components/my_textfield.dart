import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;



  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),

      // Textfield
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(

            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary)),

            focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),),

           // prefixIcon: Icon(Icons.account_balance_outlined, color: Colors.blue),
            prefixText: "(─‿‿─) ",
            prefixStyle: TextStyle(color: Colors.blue),

            fillColor: Theme.of(context).colorScheme.tertiary,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)

        ),
      ),
    );
  }

}