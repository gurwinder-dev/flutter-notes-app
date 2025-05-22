




import 'package:flutter/material.dart';
import 'package:notrepad_free/Screens/privacy_policy.dart';

import '../help.dart';

class privacySettings extends StatelessWidget {
  const privacySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Privacy settings',style: TextStyle(),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>privatePolicy('https://policies.google.com/privacy?hl=en-US')));
                },
                child: ListTile(
                  title: Text('Privacy policy',
                   // style: TextStyle(color: Colors.black,),
                  ),
                  subtitle: Text('Opens the privacy document'),
                ),
              ),
              InkWell(
                onTap: (){
                  showDialog(context: context,
                      builder: (BuildContext contect)=>AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)
                        ),

                        content: Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width/3,
                          child: Text('"Are you sure,you want to delete data?"'
                              ' It does not affect notes in any way. Notes are never sent to third party services.'
                              ' Only user have access to the notes.\nMore informatioin can be found on the Help page.',
                            style: TextStyle(
                              fontSize: 16,
                            ),),
                        ),
                        actions: [

                        Row(

                          children: [
                            TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQScreen())), child: Text('HELP')),
                           SizedBox(width:MediaQuery.of(context).size.width/4.5,),
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text('NO')),
                            TextButton(onPressed: (){
                            }, child: GestureDetector(
                                onTap:(){
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)
                                    ),
                                    content: Text("Data deletion request is being processed now by third party services."
                                        "It doesn't affect notes in any way.Notes are never sent to third party services.\n"
                                        "Only user have access to the notes.\nMore information can be found on the Help page"),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(child: Text("HELP"), onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQScreen()));
                                        }),
                                        TextButton(child: Text("OK"), onPressed: (){
                                          Navigator.pop(context);
                                        }),
                                      ],
                                    )
                                  ],),

                                  );

                                },
                                child: Text('OK')))
                          ],
                        )

                        ],

                      ));
                },
                child: ListTile(
                  title: Text('Request deletion of data',
                   // style: TextStyle(color: Colors.black,)
                    ),
                  subtitle: Text('Sends request for deleting data that stored by third '
                      ' party services like anontmized analytics data'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
