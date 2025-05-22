

import 'package:flutter/material.dart';

class note_List extends StatefulWidget {
  const note_List({super.key});

  @override
  State<note_List> createState() => _note_ListState();
}




class _note_ListState extends State<note_List> {

  bool _isOpen=false;
  bool _isShow=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
      ),
      body: Column(
        children: [
         Visibility(
           child: SwitchListTile(
              title: Text('Open the last chosen category'),
              subtitle: Text('Opens the last chosen category on app start',
               // style:TextStyle(color: Colors.blueGrey) ,
              ),

                onChanged: (bool value){
                  setState(() {
                    _isOpen=value;
                  });
                },
                value: _isOpen,
              ),
         ),

          SwitchListTile(
              onChanged: (bool value){
                setState(() {
                  _isShow=value;
                });
              },
              value: _isShow,

            title: Text('Show note categories'),
            subtitle: Text('Shows categories for each note on the list',
          //  style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}
