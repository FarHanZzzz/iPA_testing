import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chatt_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
      ),
      body:  Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),

        ),
        margin:  const EdgeInsets.all(25),
        padding: EdgeInsets.all(15),

        child: Row(
          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
            // dark mode
            Text("Dark Mode"),

            // switch toggle
            CupertinoSwitch(
                value:
                    Provider.of<ThemeProvider>(context , listen: false).isDarkMode,
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context , listen: false).toggleTheme(),
            )

        ],

        ),
      ),
    );

  }
}

