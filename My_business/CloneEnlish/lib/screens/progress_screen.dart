import 'package:flutter/material.dart';

import '../services/xp_service.dart';
import '../services/streak_service.dart';
import '../services/achievement_service.dart';

import '../widgets/achievement_card.dart';

import '../models/achievement.dart';



class ProgressScreen extends StatelessWidget {

  const ProgressScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "My Progress",
        ),

        centerTitle: true,

      ),



      body: FutureBuilder<int>(


        future: XPService.getXP(),


        builder: (context, snapshot) {



          if (!snapshot.hasData) {


            return const Center(

              child: CircularProgressIndicator(),

            );


          }



          final int xp = snapshot.data!;


          final int level =
              (xp ~/ 100) + 1;



          final double progress =
              (xp % 100) / 100;




          return SingleChildScrollView(


            padding: const EdgeInsets.all(20),



            child: Column(


              children: [



                // LEVEL CIRCLE

                CircleAvatar(

                  radius: 45,

                  backgroundColor: Colors.blue,

                  child: Text(

                    "L$level",

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),




                const SizedBox(height: 20),





                Text(

                  "$xp XP",

                  style: const TextStyle(

                    fontSize: 30,

                    fontWeight: FontWeight.bold,

                  ),

                ),





                const SizedBox(height: 20),





                LinearProgressIndicator(

                  value: progress,

                  minHeight: 12,

                  borderRadius:
                  BorderRadius.circular(10),

                ),





                const SizedBox(height: 10),





                Text(

                  "${xp % 100}/100 XP to next level",

                  style:
                  const TextStyle(fontSize: 16),

                ),





                const SizedBox(height: 30),





                // STREAK CARD

                FutureBuilder<int>(


                  future: StreakService.getStreak(),


                  builder: (context, snapshot) {



                    if(!snapshot.hasData){


                      return const CircularProgressIndicator();


                    }



                    return Card(


                      child: ListTile(


                        leading: const Icon(

                          Icons.local_fire_department,

                          color: Colors.orange,

                        ),



                        title: const Text(

                          "Current Streak",

                        ),



                        trailing: Text(

                          "${snapshot.data} Days",

                          style: const TextStyle(

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),



                      ),


                    );


                  },

                ),






                const SizedBox(height: 20),






                // ACHIEVEMENTS TITLE


                const Align(


                  alignment: Alignment.centerLeft,


                  child: Text(

                    "Achievements",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),






                const SizedBox(height: 10),






                // DYNAMIC ACHIEVEMENTS


                FutureBuilder<List<Achievement>>(



                  future:
                  AchievementService.getAchievements(),



                  builder:(context, snapshot){



                    if(!snapshot.hasData){


                      return const CircularProgressIndicator();


                    }





                    return Column(


                      children:

                      snapshot.data!


                          .map(

                            (achievement)=>


                            AchievementCard(

                              achievement: achievement,

                            ),


                      )


                          .toList(),


                    );


                  },



                ),






                const SizedBox(height: 20),






                // LESSON CARD


                Card(

                  child: ListTile(

                    leading: const Icon(

                      Icons.check_circle,

                      color: Colors.green,

                    ),


                    title: const Text(

                      "Lessons Completed",

                    ),


                    trailing: const Text(

                      "12",

                    ),


                  ),

                ),






                const SizedBox(height: 15),






                // SPEAKING CARD


                Card(

                  child: ListTile(

                    leading: const Icon(

                      Icons.mic,

                      color: Colors.blue,

                    ),


                    title: const Text(

                      "Speaking Practice",

                    ),


                    trailing: const Text(

                      "35 min",

                    ),


                  ),

                ),



              ],


            ),


          );



        },


      ),


    );

  }

}