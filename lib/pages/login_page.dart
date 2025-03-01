import 'package:flutter/material.dart';
import 'package:my_chatt_app/components/my_button.dart';
import 'package:my_chatt_app/components/my_textfield.dart';
import 'package:my_chatt_app/services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key, required this.onTap});

  // tap to go to the register page
  final void Function()? onTap;


  // login method
  void login(BuildContext context) async{

    // auth service
    final authService = AuthService();

    // try login
    try{
      await authService.signInWithEmailPassword(
          _emailController.text,
          _passwordController.text
      );
    }catch (e){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString()),));
    }

    // catch my errors
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // background color
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,
        // body
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //logo
              Icon(Icons.baby_changing_station, size: 60, color: Theme
                  .of(context)
                  .colorScheme
                  .primary,), // icon

              const SizedBox(height: 25),

              // welcome back message
              Text("Welcome to the Dungeon", style: TextStyle(color: Theme
                  .of(context)
                  .colorScheme
                  .primary, fontSize: 25)),

              const SizedBox(height: 25),

              // email textfield
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,

              ),
              const SizedBox(height: 30,),

              // pw Text field
              MyTextField(
                hintText: "password",
                obscureText: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 25),

              // login button

              MyButton(
                  text: "Login" ,
                  onTap:  () => login(context)
              ),

              const SizedBox(height: 25),

              // register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member ?", style: TextStyle(color: Theme.of(context).colorScheme.primary)),

                  GestureDetector(
                      onTap: onTap,
                      child: Text("Register Now", style: TextStyle(fontWeight:FontWeight.bold, color: Theme.of(context).colorScheme.primary))),


                ],
              )
            ],
          ),

        )

    );
  }
}