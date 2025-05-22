

import 'package:flutter/material.dart';
import 'package:notrepad_free/DBHelper.dart';

import 'AddNotes.dart';


class Trash extends StatefulWidget {
 // final Note? note;
   Trash({super.key, 
   //  required this.note
   });

  @override
  State<Trash> createState() => _TrashState();
}

class _TrashState extends State<Trash> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Trash'),
          actions: [
            IconButton(onPressed: () {},
                color: Colors.white,
                icon: PopupMenuButton(

                    itemBuilder: (_) =>
                    const <PopupMenuItem>[
                      PopupMenuItem(
                        child: Text('Restore All Notes'),
                        value: 1,

                      ),
                      // PopupMenuItem(
                      //   child: Text('Export notes to text files'),
                      //   value: 2,
                      // ),
                      PopupMenuItem(
                        child: Text('Empty trash'),
                        value: 3,
                      ),
                    ],
                    onSelected: (index) {
                      if (index == 1) {
                          DBHelper.getInstance.restoreNote();
                          setState(() {

                          });
                        }
                      if (index == 3) {
                           DBHelper.getInstance.emptyTrash();
                      setState(() {
                      });

                      }
                    }))
          ],
        ),
        body: FutureBuilder(
            future: DBHelper.getInstance.getDeletedNotes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final trashedNotes = snapshot.data!;
              if (trashedNotes.isEmpty)
                return Center(child: Text("Trash is empty."));
              print("********************$trashedNotes");
              return RefreshIndicator(
                onRefresh: ()async{
                  setState(() {

                  });
                },
                child: ListView.builder(
                    itemCount: trashedNotes.length,
                    itemBuilder: (context, index) {
                      final note = trashedNotes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        child: Card(
                          child: ListTile(
                            title: Text(note['title']),
                            subtitle: Text(note['description']),
                          ),
                        ),
                      );
                    }),
              );
            })
    );

  }

 }


