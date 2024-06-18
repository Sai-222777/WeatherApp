import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/pages/citiespage.dart';
import 'package:weatherapp/storage_service.dart';
import 'package:weatherapp/weather_service.dart';

class Weatherpage extends StatefulWidget {
  final String username;
  final String location;
  final bool isFav;
  const Weatherpage({super.key, required this.username, required this.location, required this.isFav});

  @override
  State<Weatherpage> createState() => _WeatherpageState();
}

class _WeatherpageState extends State<Weatherpage> {

  late bool isFav;

  @override 
  void initState(){
    super.initState();
    isFav = widget.isFav;
    Provider.of<WeatherService>(context,listen: false).loadData(widget.location);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
        actions: [isFav ? 
          IconButton(onPressed: () {}, icon:Icon(Icons.bookmark_remove))
          : IconButton(
            onPressed: (){
              StorageService.addLocation(widget.username, widget.location);
              setState(() {
                isFav = true; 
              });
            },
            icon: Icon(Icons.bookmark_add)
            )
          ],
      ),
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: Consumer<WeatherService>(
          builder: (context, weatherService, child) {
            return weatherService.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network('https://openweathermap.org/img/wn/${weatherService.icon}@2x.png', scale: .4,),
                      Text('${weatherService.temp}°C', style: TextStyle(fontSize: 32)),
                      Text(weatherService.condition, style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.count(
                          shrinkWrap: true,
                          childAspectRatio: 2.5,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.teal[100],
                              child: Column(
                                children: [
                                  Text("Wind Speed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
                                  Text('${weatherService.speed} m/s', style: TextStyle(fontSize: 22.0),)
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.teal[200],
                              child: Column(
                                children: [
                                   Text("Humidity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
                                   Text('${weatherService.humidity} %', style: TextStyle(fontSize: 22.0),)
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.teal[100],
                              child: Column(
                                children: [
                                   Text("Visibilty", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
                                   Text('${weatherService.visibility} km', style: TextStyle(fontSize: 22.0),)
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.teal[200],
                              child: Column(
                                children: [
                                   Text("Pressure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
                                   Text('${weatherService.pressure} hpa', style: TextStyle(fontSize: 22.0),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Citiespage(username: widget.username,)));
        },
        child: Icon(Icons.location_on),
        ),
    );
  }
}