


import 'package:flutter/material.dart';

class note_Editing extends StatefulWidget {
  const note_Editing({super.key});

  @override
  State<note_Editing> createState() => _note_EditingState();
}
class _note_EditingState extends State<note_Editing> {
  bool _isShowNotekey = false;
  bool _isShowTextformating=false;
  bool _isSwitchSaveUndoButton=false;
  bool _isSaveNoteAuto=false;
  bool _isConfirmdroppingUnsaved=false;
  bool _isOpenNotesRead=false;
  bool _isKeepScreenOn=false;
  bool _isDisabletextAutoComp=false;
  bool _isLinedBG=false;
  bool _isClickableLinks=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note editing'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           SwitchListTile(
               value:_isShowNotekey,
               onChanged: (bool value){
                 setState(() {
                   _isShowNotekey=value;
                 });
               },
             title:Text('Show note keyboard') ,
             subtitle:Text('Show keyboard after entering the note screen',
              // style: TextStyle(color: Colors.blueGrey),
             ) ,
           ),
            ListTile(
              title: Text('Cursor position in a note'),
              subtitle:Text('Cursor position after opening a note with keyboard visible',
              //style: TextStyle(color: Colors.blueGrey),
              ) ,
            ),
            SwitchListTile(
              value: _isShowTextformating,
              onChanged: (bool value){
                setState(() {
                 _isShowTextformating=value;
                });
              },
              title:Text('Show text formatting toolbar') ,
              subtitle:Text('Shows a bar with txet formatting tools (e.g. setting bold font)',
             // style: TextStyle(color: Colors.blueGrey),
              ) ,
            ),
            ListTile(
              title: Text('Default note text font size'),
              subtitle:Text('18',
              //  style: TextStyle(color: Colors.blueGrey),
              )
        
            ),
            SwitchListTile(
                value:_isSwitchSaveUndoButton,
                onChanged:(bool value){
                  setState(() {
                    _isSwitchSaveUndoButton=value;
                  });
                },
              title: Text('Switch "Save" and "Undo" buttons '),
              subtitle: Text('Switches the "Save" and "Undo" buttons placement',
            //  style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            SwitchListTile(
              value: _isSaveNoteAuto,
              onChanged:(bool value){
                setState(() {
                 _isSaveNoteAuto=value;
                });
              },
              title: Text('Save notes automatically'),
              subtitle: Text('Changes in notes are saved automatically.Disabling it may cause losing unsaved parts of notes'
                //, style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            SwitchListTile(
                value: _isConfirmdroppingUnsaved,
                onChanged: (bool value){
                  _isConfirmdroppingUnsaved=value;
                },
            title: Text('Confirm dropping unsaved changes'),
            subtitle: Text('Asks for confirmation before closing a note with unsaved chnges',
           // style:TextStyle(color: Colors.blueGrey),
            )
              ,),
            SwitchListTile(
              value: _isOpenNotesRead,
              onChanged: (bool value){
                _isOpenNotesRead=value;
              },
              title: Text('Open notes in read mode'),
              subtitle: Text('Open notes in read mode by default',
              //  style: TextStyle(color: Colors.blueGrey),
              ),),
            SwitchListTile(
              value: _isKeepScreenOn,
              onChanged: (bool value){
                   _isKeepScreenOn=value;
              },
              title: Text('Lined background'),
              subtitle: Text('Puts lines on the background page of the note',
               // style: TextStyle(color: Colors.blueGrey),
              ),),
            SwitchListTile(
              value: _isDisabletextAutoComp,
              onChanged: (bool value){
              _isDisabletextAutoComp=value;
              },
              title: Text('Disable text autocomplete'),
              subtitle: Text('Disables phone keyboard autocomplete feature.May cause side effects, for example'
                  'siabling starting sentences with a capital letter.'
                  'Recommended solution is to disable autocompletion directly in the phone keyboard setting',
             // style: TextStyle(color: Colors.blueGrey),
              ),),
        
            SwitchListTile(
              value: _isLinedBG,
              onChanged: (bool value){
              _isLinedBG=value;
              },
              title: Text('Lined background'),
              subtitle: Text('Puts lines on the background page of the note'),),
             ListTile(
               title: Text('Line numbers'),
               subtitle: Text('Displays the line number next to a line',
              // style: TextStyle(color: Colors.blueGrey),
               ),
             ),
            SwitchListTile(
              value: _isClickableLinks,
              onChanged: (bool value){
                _isClickableLinks=value;
              },
              title: Text('Clickable links'),
              subtitle: Text('Clicking a link in a note will open it in an external app',
             // style: TextStyle(color: Colors.blueGrey),
              ),),
          ],
        ),
      ),
    );
  }
}
