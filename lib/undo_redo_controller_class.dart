

import 'package:flutter/cupertino.dart';

class UndoRedoController extends ChangeNotifier{
  ///Store old value (for Undo)
  final List<String> _past=[];

  /// Current value
   String _present ='';
  ///stores undone values (for redo)
  final List<String> _future=[];

  String get present=>_present;
  late String _initial;
  String? _clearedText;
  /// Store cleared text to allow redo after clear
  void setInitial(String text) {
    _initial = text;
    _present = text;
    _past.clear();
    _future.clear();
    _clearedText = null;
    notifyListeners();
  }

  ///  Called whenever user types something new
   void settext(String newtext){
     if(newtext!=_present){

       ///Save current value to past
       _past.add(_present);
       ///Update new value
       _present=newtext;
       /// Clear redo history
       _future.clear();
       /// update UI
       notifyListeners();
     }
   }
   /// Called when user hits "Undo"

void undo(){
     if(_past.isNotEmpty){
       debugPrint("Undoing: $_present → ${_past.last}");
       ///move current value to future
       _future.add(_present);
       ///pop last from past
       _present=_past.removeLast();
       ///update UI
       notifyListeners();
     }
}

  /// Called when user hits 'Redo'

  void redo(){
     if(_future.isNotEmpty){
       debugPrint("Redoing: $_present → ${_future.last}");
       ///save current to past
       _past.add(_present);
       ///pop from future
       _present=_future.removeLast();
       ///update UI
       notifyListeners();
     }
  }

}