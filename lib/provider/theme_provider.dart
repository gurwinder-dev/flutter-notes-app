
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider with ChangeNotifier {
  int _themeIndex = 1; // Default is Light

  int get themeIndex => _themeIndex;

  // Constructor to load theme from SharedPreferences
  ThemeProvider() {
    _loadTheme();
  }

  // Load theme index from SharedPreferences
  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeIndex = prefs.getInt('themeIndex') ?? 1; // Default to Light if not found
    notifyListeners();
  }

  // Save theme to SharedPreferences
  _saveTheme(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeIndex', index);
  }

  // Change theme
  void setTheme(int index) {
    _themeIndex = index;
    _saveTheme(index);
    notifyListeners();
  }

  // Get the current theme data (to switch the theme in the app)
  ThemeData get themeData {
    switch (_themeIndex) {
      case 1:
        return ThemeData.light().copyWith(appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(color: const Color(0xFFFFFFFF),fontSize: 18),
            iconTheme: IconThemeData(color: Colors.white,),
            color: const Color(0xFF006E1C),

        ),
          drawerTheme:DrawerThemeData(backgroundColor: Colors.green.shade50) ,
           scaffoldBackgroundColor: const Color(0xFFFFFFFF),// white color for text

            floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: const Color(0xFF006E1C),// dark green for appbar and body text , button color
              foregroundColor: const Color(0xFFFFFFFF),),
            textTheme: TextTheme(bodySmall: TextStyle(color:const Color(0xFF006E1C )),
              bodyLarge: TextStyle(color: const Color(0xFF006E1C )), // Default color for headline1
              bodyMedium: TextStyle(color:const Color(0xFF006E1C )), // Default color for headline2
              displaySmall: TextStyle(color: const Color(0xFF006E1C )),
              headlineSmall: TextStyle(color: Colors.pink),// Default color for headline3)
              headlineLarge: TextStyle(color: Colors.pink),// Default color for headline3)
              headlineMedium: TextStyle(color: Colors.pink),// Default color for headline3)
            ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(backgroundColor:MaterialStateProperty.all(const Color(0xFF006E1C )),
              foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFFFF) ,
              )
            )
          ),



            );
      case 2:
        return ThemeData.dark().copyWith( brightness: Brightness.light,
            // primaryColor: Color(0xFF268BD2), // Solarized Blue
            //
            // colorScheme: ColorScheme.light(
            //   primary: Color(0xFF268BD2),
            //   secondary: Color(0xFF2AA198),



    ); // Example for Solarized
      case 3:
        return ThemeData.dark();
      case 4:
        return ThemeData.light().copyWith(primaryColor: Colors.white);
      case 5:
        return ThemeData.dark().copyWith(primaryColor: Colors.black);
      default:
        return ThemeData.light();
    }
  }
}
