import 'package:flutter/material.dart';
import 'package:my_chatt_app/pages/settings_page.dart';
import 'package:my_chatt_app/services/auth/auth_service.dart';


class drawer extends StatelessWidget {
  const drawer({super.key});



  void logout(){
    // get auth service
    final auth = AuthService();
    auth.signOut();


  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            // logo
            DrawerHeader(
              child: Center(
                child: Icon(Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40
                ),
              ),
            ),


            // home list tiles
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: const Text("H O M E"),
                leading: const Icon(Icons.home),
                onTap: () {
                  // pop the drawer
                  Navigator.pop(context);
                },
              ),
            ),


            // setting list tiles

            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: const Text("S E T T I N G S"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  // pop the drawer
                  Navigator.pop(context);
                  
                  // navigator to settings page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder:  (context) => const SettingsPage(),
                      )
                  );
                },
              ),
            ),
          ],),



          // logout list tiles
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout,

            ),
          ),
        ]

        // home list tiles

        // settings list tiles

        // logout list tile

      ),
    );
  }
}
