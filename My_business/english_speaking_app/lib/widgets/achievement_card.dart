import 'package:flutter/material.dart';
import '../models/achievement.dart';



class AchievementCard extends StatelessWidget {


  final Achievement achievement;



  const AchievementCard({

    super.key,

    required this.achievement,

  });





  @override
  Widget build(BuildContext context) {


    return Card(


      elevation: 4,


      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),


      child: ListTile(


        leading: Text(

          achievement.icon,

          style: const TextStyle(
            fontSize: 35,
          ),

        ),




        title: Text(

          achievement.title,

          style: TextStyle(

            fontWeight:
            FontWeight.bold,


            color:
            achievement.unlocked
                ? Colors.green
                : Colors.grey,

          ),

        ),





        subtitle: Text(

          achievement.description,

        ),





        trailing: Icon(

          achievement.unlocked
              ? Icons.check_circle
              : Icons.lock,


          color:

          achievement.unlocked
              ? Colors.green
              : Colors.grey,

        ),


      ),

    );


  }


}