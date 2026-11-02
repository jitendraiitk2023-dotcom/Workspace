import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/xp_service.dart';
import '../services/achievement_service.dart';



class LessonScreen extends StatefulWidget {


  final String topic;


  const LessonScreen({

    super.key,

    required this.topic,

  });



  @override
  State<LessonScreen> createState() =>
      _LessonScreenState();

}




class _LessonScreenState extends State<LessonScreen> {



  late stt.SpeechToText speech;


  bool isListening = false;


  bool lessonCompleted = false;


  String spokenText = "";




  final List<String> questions = [


    "Introduce yourself",

    "What is your daily routine?",

    "What are your hobbies?",

    "Describe your family",

    "What is your favorite food?"


  ];




  int currentQuestion = 0;





  @override
  void initState() {

    super.initState();

    speech = stt.SpeechToText();

  }







  void startListening() async {


    bool available =
    await speech.initialize();



    if(available){


      setState(() {

        isListening = true;

      });




      speech.listen(


        onResult: (result){


          setState(() {


            spokenText =
                result.recognizedWords;


          });


        },


      );


    }


  }






  void stopListening(){


    speech.stop();


    setState(() {


      isListening = false;


    });


  }








  Future<void> completeLesson() async {



    if(lessonCompleted){

      return;

    }



    lessonCompleted = true;




    // Add XP

    await XPService.addXP(20);




    // Unlock achievement

    await AchievementService.completeLesson();





    showDialog(


      context: context,


      barrierDismissible:false,


      builder:(context){


        return AlertDialog(


          title: const Text(

            "🎉 Congratulations!",

          ),




          content: const Text(

            "You completed this lesson!\n\n"

                "⭐ +20 XP\n"

                "🎯 Achievement Updated",

          ),




          actions:[



            ElevatedButton(


              onPressed:(){


                Navigator.pop(context);


                Navigator.pop(context);



              },


              child:const Text(

                "Continue",

              ),



            )


          ],



        );

      },


    );



  }








  void nextQuestion(){



    if(currentQuestion < questions.length - 1){



      setState((){


        currentQuestion++;


        spokenText="";



      });



    }

    else{


      completeLesson();



    }


  }









  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar:AppBar(


        title:Text(widget.topic),


        centerTitle:true,


      ),





      body:Padding(


        padding:const EdgeInsets.all(20),



        child:Column(



          mainAxisAlignment:
          MainAxisAlignment.center,



          children:[






            Text(


              "Question ${currentQuestion+1}/${questions.length}",


              style:const TextStyle(


                fontSize:20,


                fontWeight:FontWeight.bold,


              ),



            ),






            const SizedBox(height:30),







            Text(


              questions[currentQuestion],



              textAlign:TextAlign.center,



              style:const TextStyle(


                fontSize:24,


                fontWeight:FontWeight.bold,


              ),



            ),







            const SizedBox(height:40),







            GestureDetector(



              onTap:(){



                if(isListening){


                  stopListening();


                }

                else{


                  startListening();


                }


              },




              child:CircleAvatar(



                radius:45,



                child:Icon(



                  isListening

                      ? Icons.stop

                      : Icons.mic,



                  size:45,



                ),



              ),



            ),






            const SizedBox(height:30),







            Text(


              spokenText.isEmpty

                  ? "Speak your answer"

                  : spokenText,



              textAlign:TextAlign.center,



              style:const TextStyle(


                fontSize:18,


              ),



            ),







            const SizedBox(height:40),








            SizedBox(



              width:double.infinity,



              height:55,



              child:ElevatedButton(



                onPressed:nextQuestion,



                child:const Text(


                  "Next Question",



                  style:TextStyle(


                    fontSize:18,


                  ),


                ),



              ),



            )





          ],


        ),


      ),


    );



  }



}