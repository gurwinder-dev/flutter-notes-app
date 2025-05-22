



// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// Future<Database> openDb() async{
//   var databasePath = await getDatabasesPath();
//   String path=join(databasePath,'my_database.db');
//
//   return openDatabase(path,version: 1,onCreate: (db,version){
//     db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT)');
//   });
// }


import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Database database;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    -_initializeDatabase();
  }

  _initializeDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'demo.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT)",
        );
      },
      version: 1,
    );
    _loadItems();
  }

  _loadItems() async {
    final List<Map<String, dynamic>> items = await database.query('items');
    setState(() {
      _items = items;
    });
  }

  _insertItem() async {
    await database.insert(
      'items',
      {'name': 'Item ${_items.length + 1}'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadItems();
  }

  _deleteItem(int id) async {
    await database.delete(
      'items',
      where: "id = ?",
      whereArgs: [id],
    );
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQFlite Example')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item['name']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteItem(item['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _insertItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
























//import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:notrepad_free/provider/theme_provider.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider with ChangeNotifier{
//   static const  String _key='theme';
//
//  static  bool _isDarkMode=false;


//  static bool get isDarkMode=>_isDarkMode;
//
//   //load  the theme from SharedPreference
// Future<void> loadTheme()async{
//     final sp= await SharedPreferences.getInstance();
//     _isDarkMode=sp.getBool(_key)??false;
//     notifyListeners();
// }
// // change the theme and SharedPreferences
//
// Future<void> toggleTheme(bool value)async{
//   _isDarkMode=!_isDarkMode;
//   final sp= await SharedPreferences.getInstance();
//   await sp.setBool(_key,_isDarkMode);
//   notifyListeners();
// }
//
// }
//
// class AppThemes {
//   static ThemeData get whiteTheme {
//     return ThemeData.light().copyWith(
//       primaryColor: Colors.white,
//       scaffoldBackgroundColor: Colors.white,
//       appBarTheme: AppBarTheme(color: Colors.white),
//       textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)),
//     );
//   }
//
//   static ThemeData get solarizedLight {
//     return ThemeData.light().copyWith(
//       primaryColor: Color(0xFFEEE8D5), // Solarized Light Background
//       scaffoldBackgroundColor: Color(0xFFEEE8D5),
//       appBarTheme: AppBarTheme(color: Color(0xFFEEE8D5)),
//       textTheme: TextTheme(bodyText2: TextStyle(color: Color(0xFF586E75))), // Solarized text color
//     );
//   }
//
//   static ThemeData get solarizedDark {
//     return ThemeData.dark().copyWith(
//       primaryColor: Color(0xFF073642), // Solarized Dark Background
//       scaffoldBackgroundColor: Color(0xFF073642),
//       appBarTheme: AppBarTheme(color: Color(0xFF073642)),
//       textTheme: TextTheme(bodyText2: TextStyle(color: Color(0xFF93A1A1))), // Solarized text color
//     );
//   }
//
//   static ThemeData get systemTheme {
//     return ThemeData(
//       brightness: Brightness.light,
//       primaryColor: Colors.blue,
//     );
//   }
// static  ThemeData get lighttheme {
//   return ThemeData(
//     brightness: Brightness.light,
//     primaryColor: const Color(0xFFB1D2DF),
//     scaffoldBackgroundColor: const Color(0xFFB1D2DF),
//   );
// }
//   static ThemeData get darktheme{
//     return ThemeData(
//         brightness: Brightness.dark,
//         primaryColor: const Color(0xFFB1D2DF),
//         scaffoldBackgroundColor: const Color(0xFFB1D2DF)
//     );
//   }
//
// }
//
// class ThemeProvider with ChangeNotifier {
//   static  bool _isDarkMode = false; // This is for dark/light mode.
//  bool get isDarkMode => _isDarkMode;
//
//   // final SettingsProvider settingsProvider;
//   //
//   ThemeProvider(this.settingsProvider) {
//     _isDarkMode = settingsProvider.currentTheme == 'Dark';
//   }
//
//   void toggleTheme(bool isDark) {
//     _isDarkMode = isDark;
//     notifyListeners();
//   }
//
//   // Call this when you want to apply the theme to your app
//   ThemeData get theme {
//     return _isDarkMode ? ThemeData.dark() : ThemeData.light();
//   }
