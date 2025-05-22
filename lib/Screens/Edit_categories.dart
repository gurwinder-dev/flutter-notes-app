

import 'package:flutter/material.dart';
import 'package:notrepad_free/Screens/addeditcategory.dart';
import 'package:notrepad_free/main.dart';



class editCategories extends StatefulWidget {
   editCategories({super.key});

  @override
  State<editCategories> createState() => _editCategoriesState();
}

class _editCategoriesState extends State<editCategories> {
  @override
  final TextEditingController _textEditingController=TextEditingController();
  TextEditingController _controller= TextEditingController();

 String?  category;


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Categories'),
    ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: TextField(
                  controller: _textEditingController,
                  cursorColor: Colors.black87,
                  decoration: InputDecoration(
                    hintText: 'New Category name',
                  ),


                ),
                trailing: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1)),
                      ), onPressed: () {
                      setState(() {
                       category =_textEditingController.text;
                       _controller.text=category!;
                        _textEditingController.clear();

                      });
                  },


                      child: Text('ADD',style: TextStyle(),)),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined),
                    suffixIcon: InkWell(
                      onTap: (){
                       showDialog(context: context,
                           builder: (BuildContext context)=>AlertDialog(
                             content: Text('Delete category "$category"? Notes from the category would be deleted'),
                             actions: [
                               TextButton(onPressed: (){
                                 Navigator.pop(context);
                               },
                                   child: Text('CANCEL')),
                               TextButton(onPressed: (){
                                 _controller.clear();
                                 Navigator.pop(context);
                               },
                                   child:Text('OK') ),
                             ],

                           ));
                      },
                        child: Icon(Icons.delete)),
                    suffix: InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                          title: Text('Edit category name'),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Name category name'
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            },
                                child: Text('CANCEL')),
                            TextButton(onPressed: (){
                              _controller.clear();
                              Navigator.pop(context);
                            },
                                child: Text('OK')),
                          ],
                        ));
                      },
                        child: Icon(Icons.edit))

                  ),
                ),
              )

   ] ));
  }
}


