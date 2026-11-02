import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/achievement_service.dart';



class VocabularyScreen extends StatefulWidget {

  const VocabularyScreen({super.key});


  @override
  State<VocabularyScreen> createState() =>
      _VocabularyScreenState();

}





class _VocabularyScreenState extends State<VocabularyScreen> {



  final List<Map<String,String>> words = [


    {
      "word":"Beautiful",
      "meaning":"Very attractive"
    },


    {
      "word":"Improve",
      "meaning":"To make something better"
    },


    {
      "word":"Confident",
      "meaning":"Feeling sure about yourself"
    },


    {
      "word":"Opportunity",
      "meaning":"A good chance"
    },


    {
      "word":"Practice",
      "meaning":"Doing something repeatedly"
    },


  ];





  Set<int> learnedWords = {};




  @override
  void initState() {

    super.initState();

    loadLearnedWords();

  }







  Future<void> loadLearnedWords() async {


    final prefs =
    await SharedPreferences.getInstance();


    List<String> saved =
        prefs.getStringList(
          "learned_words",
        ) ?? [];



    setState(() {


      learnedWords =
          saved.map(
                  (e)=>int.parse(e)
          ).toSet();


    });


  }








  Future<void> markAsLearned(int index) async {



    if(learnedWords.contains(index)){


      return;


    }



    await AchievementService.learnWord();




    learnedWords.add(index);




    final prefs =
    await SharedPreferences.getInstance();



    await prefs.setStringList(

      "learned_words",

      learnedWords
          .map((e)=>e.toString())
          .toList(),

    );





    setState(() {});




    ScaffoldMessenger.of(context)
        .showSnackBar(


      SnackBar(

        content: Text(

          "${words[index]["word"]} learned 📚",

        ),

      ),


    );



  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title:
        const Text(
          "Vocabulary",
        ),


        centerTitle:true,


      ),






      body:ListView.builder(



        padding:
        const EdgeInsets.all(20),



        itemCount:
        words.length,



        itemBuilder:(context,index){



          bool learned =
          learnedWords.contains(index);





          return Card(


            child:ListTile(



              leading:const Text(

                "📚",

                style:
                TextStyle(

                  fontSize:30,

                ),

              ),




              title:Text(

                words[index]["word"]!,

                style:const TextStyle(

                  fontWeight:
                  FontWeight.bold,

                ),

              ),




              subtitle:Text(

                words[index]["meaning"]!,

              ),





              trailing:IconButton(



                icon:Icon(


                  learned

                      ? Icons.check_circle

                      : Icons.add_circle,



                  color:

                  learned

                      ? Colors.green

                      : Colors.blue,


                ),



                onPressed:(){


                  markAsLearned(index);


                },


              ),



            ),


          );


        },


      ),


    );


  }


}