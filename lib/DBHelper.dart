import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notrepad_free/Screens/AddNotes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DBHelper {
  /// Singleton
  DBHelper._init();
  static final DBHelper getInstance = DBHelper._init();
  /// Database object
 static Database? myDB;

  /// Table and Column names
  //static final String Table_Note = "note";
 // static final String COL_NOTE_SNO = "s_no";
  static final String COL_NOTE_TITLE = "title";
  static final String COL_NOTE_DESC = "description";


  /// Get current date and time in the format 'dd/MM/yy hh:mma'
  String formatDate(DateTime dateTime) {
    var formatter = DateFormat('dd/MM/yy hh:mma');
    return formatter.format(dateTime);
  }

  /// Open the database
  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  /// Create and open the database
  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'noteDB.db');

    print("***********************************Database Path: $dbPath");  ///Print path for debugging

    /// Ensure database creation and handle possible old database issues
   // await deleteDatabase(dbPath);  // Delete the existing database for a fresh start
    print("Deleted old database (if any).");
    // 🔥 This line deletes your old database (so it recreates it with new columns)
   // await deleteDatabase(dbPath);
    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        print("Creating Table...");  // Debugging table creation
        await db.execute('''
          CREATE TABLE note (
            s_no INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_NOTE_TITLE TEXT,
            $COL_NOTE_DESC TEXT,
             created_at TEXT,
             noteColor INTEGER,
              isDeleted INTEGER DEFAULT 0
          )
        ''');


        print("Table Created Successfully.");  // Confirm table creation
      },
      onUpgrade:  (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE note ADD COLUMN isDeleted INTEGER DEFAULT 0');
        }
      }
    );
  }

  /// Add a new note to the database
  Future<bool> addNote( {required String mTitle, required String mDesc , required int mNoteColor}) async {
    var db = await getDB();
    // Get current date and time in the desired format
    String createdAt = formatDate(DateTime.now());

    int rowsAffected = await db.insert('note', {

      COL_NOTE_TITLE: mTitle,
      COL_NOTE_DESC: mDesc,
      'noteColor': mNoteColor,
      'created_at':  createdAt, // Store formatted date and time
      'isDeleted': 0, // Add this if using soft delete
    },
    conflictAlgorithm: ConflictAlgorithm.replace
    );

    return rowsAffected > 0;
  }

  /// Get all notes from the database
  ///   //Select all
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    return await db.query(
        'note',
         where: 'isDeleted=0',
      orderBy: 'created_at DESC',
    );
  }

  Future<void> updateNote(int sNO, String title, String description, int noteColor,) async {
    final db = await getDB();

    int count = await db.update(
      'note',
      {
        'title': title,
        'description': description,
         'noteColor':  noteColor,

      },
      where: 's_no = ?',
      whereArgs: [sNO],
    );

    if (count > 0) {
      print('Note updated successfully. title $title');
    } else {
      print('No note found with s_no = $sNO');
    }
  }
  Future<int> delete(int sNo)async{
     final db= await getDB();
     return db.delete('note', where: 's_no=?',whereArgs: [sNo]);

  }
  ////////////////////////////////////////////////////////
  Future<void> moveNoteToTrash(int sNo) async {
    final db = await getDB();
    await db.update(
      'note',
      {'isDeleted': 1},
      where: 's_no = ?',
      whereArgs: [sNo],
    );
  }

  Future<List<Map<String, dynamic>>> getDeletedNotes() async {
    final db = await getDB();
    return await db.query(
      'note',
      where: 'isDeleted = 1',

    );
  }
  Future<void> restoreNote() async {
    final db = await getDB();
    await db.update(
      'note',
      {'isDeleted': 0},
      where: 'isDeleted = ?',
      whereArgs: [1],
    );
  }
  Future<void> emptyTrash() async{
     final db= await getDB();
     await db.delete(
         'note' ,
     where: 'isDeleted=?' ,
         whereArgs: [1] ,
     );
  }

  Future<Note?> getNoteById(int id) async{
    final db= await getDB();
    List<Map<String, dynamic>> result=await db.query(
      'note',
      where: 's_no=?',
      whereArgs: [id]
    );
    if(result.isNotEmpty){
      return Note.fromMap(result.first);
    }
    return null;

  }


   /// Sorting Notes by Title A-Z
   Future<List<Note>> getNotesSortedByTitleAZ() async{
    final db=await getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'note',
        where: 'isDeleted = 0', //  filter out deleted notes
      orderBy: 'title COLLATE NOCASE ASC'  /// ASC = A to Z
    );
    return maps.map((map) =>Note.fromMap(map)).toList();
   }

     Future<List<Note>> getNotesSortedByTitleZA() async{
    final db= await getDB();
    final List<Map<String , dynamic>> maps = await db.query(
      'note',
        where: 'isDeleted = 0', //  filter out deleted notes
      orderBy: 'title COLLATE NOCASE DESC' /// DESC = Z TO A
    );
    return maps.map((map) => Note.fromMap(map)).toList();
     }
      Future<List<Note>> getNotesSortedByDateNewest() async{
    final db=await getDB();
    final maps=await db.query(
      'note',
      where: 'isDeleted=0',
        orderBy:'created_at DESC',
    );
    return maps.map((map) =>Note.fromMap(map)).toList();
      }

      Future<List<Note>> getNotesSortedByOldest() async{
    final db=await getDB();
    final maps=await db.query(
      'note',
      where: 'isDeleted=0',
      orderBy:'created_at ASC',
    );
    return maps.map((map) => Note.fromMap(map)).toList();
      }

 }


class Note {
  final int s_no;
  final String title;
  final String description;
  final String? createdAt;
  final int? noteColor;


  Note({
    required this.s_no,
    required this.title,
    required this.description,
    this.createdAt,
    this.noteColor,

  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      s_no: map['s_no'] ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      createdAt: map['created_at']?.toString(),
      noteColor: map['noteColor'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      's_no': s_no,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'noteColor' : noteColor,

    };
  }
  String toString() {
    return 'Note(title: $title, desc: $description, createdAt: $createdAt)';
  }
  // Get real Color object from stored int
  Color get color => noteColor!=null? Color(noteColor!) :Colors.green.shade400 ;
}
