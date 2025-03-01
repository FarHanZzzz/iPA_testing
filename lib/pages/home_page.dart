import 'package:flutter/material.dart';
import 'package:my_chatt_app/components/drawer.dart';
import 'package:my_chatt_app/components/user_tile.dart';
import 'package:my_chatt_app/pages/chat_page.dart';
import 'package:my_chatt_app/services/auth/auth_service.dart';
import 'package:my_chatt_app/services/chat/chat_services.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});


  // chat and auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();



  void logout(){
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,

      ),
      drawer: const drawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context,snapshot) {

          // error
          if(snapshot.hasError) {
            return const Text("Error");
          }

          // loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading..");
          }

          // return  list view
          return ListView(
            children: snapshot.data!.map<Widget>((userData)  => _buildUserListitem(userData,context))
              .toList(),
          );

        },
    );
  }




  // build individual list tile for user


  Widget  _buildUserListitem(
      Map<String,dynamic> userData, BuildContext context) {
    // display all users except current users

    if(userData["email"] != _authService.getCurrentUser()){
      return UserTile(
        text: userData["email"],
        onTap:() {
          // tapped on a user - > go to chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                  receiverID:  userData["uid"],
                ),
              ));
        },
      );
    }else {
      return Container();
    }
  }

}

