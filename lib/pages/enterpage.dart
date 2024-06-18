import 'package:flutter/material.dart';
import 'package:weatherapp/components/my_text_field.dart';
import 'package:weatherapp/pages/weatherpage.dart';
import 'package:weatherapp/storage_service.dart';

class Enterpage extends StatefulWidget {
  const Enterpage({super.key});

  @override
  State<Enterpage> createState() => _EnterpageState();
}

class _EnterpageState extends State<Enterpage> {

  final usernameController = TextEditingController();
  final locationController = TextEditingController();
  String? location;


  void enter() async {
    if(usernameController.text.isEmpty)
    {
      return;
    }
    location = await StorageService.getUserlocation(usernameController.text);
    if(location == null)
    {
      if(locationController.text.isEmpty)
      {
        return;
      }
      print('creating');
      StorageService.storeUserlocation(usernameController.text, locationController.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Weatherpage(username: usernameController.text, location: locationController.text, isFav: true,)));
    }
    else
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Weatherpage(username: usernameController.text, location: location!, isFav: true,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('WEATHER APP')),
        backgroundColor: Colors.blue.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(controller: usernameController, hintText: 'Enter Username', obscureText: false),
            Container(
              padding: EdgeInsets.all(2),
              child: TextButton(
                onPressed: enter,
                child: Text('Enter')
                )
            ),
            MyTextField(controller: locationController, hintText: 'Enter Location if New User', obscureText: false),
          ],
        ),
      ),
    );
  }
}