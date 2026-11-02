import 'package:flutter/material.dart';
import '../services/api_service.dart';


class BackendTestScreen extends StatefulWidget {

  const BackendTestScreen({
    super.key,
  });


  @override
  State<BackendTestScreen> createState() =>
      _BackendTestScreenState();

}



class _BackendTestScreenState
    extends State<BackendTestScreen> {


  String message = "Testing AI Backend...";



  @override
  void initState() {

    super.initState();

    testBackend();

  }




  Future<void> testBackend() async {


    final result =
        await ApiService.sendMessage(
          "Hello",
        );


    setState(() {

      message = result;

    });


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Backend Test",
        ),

      ),



      body: Center(


        child: Text(

          message,


          textAlign: TextAlign.center,


          style: const TextStyle(

            fontSize: 22,

            fontWeight: FontWeight.bold,

          ),

        ),


      ),


    );


  }


}