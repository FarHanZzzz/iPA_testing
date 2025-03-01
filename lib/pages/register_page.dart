import 'package:flutter/material.dart';
import 'package:my_chatt_app/components/my_button.dart';
import 'package:my_chatt_app/components/my_textfield.dart';
import 'package:my_chatt_app/services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();


  final void Function()? onTap;


  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context){

    //get auth service
    final auth = AuthService();

    // password matches create user
    if(_passwordController.text==_confirmController.text) {
      try {
        auth.signupWithEmailPassword(
            _emailController.text,
            _passwordController.text
        );
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text(e.toString())
                  ,
                )
        );
      }
    }// password does not match
    else{
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(title: Text("passwordc does not match"),));

    }
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //logo
              Icon(Icons.account_balance_outlined, size: 60, color: Theme
                  .of(context)
                  .colorScheme
                  .primary,), // icon

              const SizedBox(height: 25),

              // welcome back message
              Text("Register Page ", style: TextStyle(color: Theme
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
              const SizedBox(height: 25,),

              // pw Text field
              MyTextField(
                hintText: "password",
                obscureText: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 25),

              // confirm password text
              MyTextField(
                hintText: "Confirm password",
                obscureText: true,
                controller: _confirmController,
              ),


              const SizedBox(height: 25),

              // login button

              MyButton(
                  text: "Register" , 
                  onTap: () => register(context)
              ),

              const SizedBox(height: 25),

              // register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text("Already have an account?", style: TextStyle(fontWeight:FontWeight.normal,color: Theme.of(context).colorScheme.primary)),

                  GestureDetector(
                      onTap: onTap,
                      child: Text("Login now ", style: TextStyle(fontWeight:FontWeight.bold, color: Theme.of(context).colorScheme.primary))),

                ],
              )

            ],
          ),


        )

    );

  }

}