import 'package:flutter/material.dart';

import '../models/speaking_result.dart';



class SpeakingResultScreen extends StatelessWidget {


  final SpeakingResult result;



  const SpeakingResultScreen({

    super.key,

    required this.result,

  });




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar:AppBar(

        title:
        const Text(
          "AI Feedback",
        ),

        centerTitle:true,

      ),




      body:Padding(


        padding:
        const EdgeInsets.all(20),



        child:Column(



          children:[



            Card(


              child:ListTile(


                leading:
                const Icon(
                  Icons.record_voice_over,
                  color:Colors.blue,
                ),


                title:
                const Text(
                  "Pronunciation Score",
                ),


                trailing:
                Text(
                  "${result.pronunciationScore}%",
                ),


              ),

            ),





            Card(


              child:ListTile(


                leading:
                const Icon(
                  Icons.spellcheck,
                  color:Colors.green,
                ),


                title:
                const Text(
                  "Grammar Score",
                ),


                trailing:
                Text(
                  "${result.grammarScore}%",
                ),


              ),

            ),






            Card(


              child:ListTile(


                title:
                const Text(
                  "Fluency",
                ),


                subtitle:
                Text(
                  result.fluency,
                ),


              ),

            ),






            const SizedBox(height:20),





            const Align(

              alignment:
              Alignment.centerLeft,


              child:Text(

                "AI Feedback",

                style:
                TextStyle(

                  fontSize:20,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            ),




            Text(
              result.feedback,
            ),






            const SizedBox(height:20),





            const Align(

              alignment:
              Alignment.centerLeft,


              child:Text(

                "Better Sentence",

                style:
                TextStyle(

                  fontSize:20,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            ),





            Text(
              result.correction,
            ),



          ],


        ),


      ),


    );


  }


}