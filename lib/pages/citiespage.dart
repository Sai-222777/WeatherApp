import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/components/my_text_field.dart';
import 'package:weatherapp/pages/weatherpage.dart';
import 'package:weatherapp/storage_service.dart';
import 'package:weatherapp/weather_service.dart';

class Citiespage extends StatefulWidget {
  final String username;
  const Citiespage({super.key, required this.username});

  @override
  State<Citiespage> createState() => _CitiespageState();
}

class _CitiespageState extends State<Citiespage> {
  final TextEditingController searchController = TextEditingController();
  List<String>? cities;
  String? city;

  @override
  void initState()
  {
    super.initState();
    loadCities();
  }

  void loadCities() async {
    cities = await StorageService.getLocations(widget.username);
    if(cities!=null)
    {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<WeatherService>(context, listen: false).loadCityWeatherData(cities!);
    });
    }
  }

  void goToWeatherPage(String city) async{
    bool isFav = await StorageService.isFavoriteCity(widget.username, city);
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => Weatherpage(username: widget.username,location: city,isFav: isFav,))
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a City'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: searchController,
                      hintText: 'Enter City Name',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (searchController.text.isEmpty) {
                        return;
                      }
                      goToWeatherPage(searchController.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<WeatherService>(
                    builder: (context,weatherService,child){
                      if(weatherService.isLoading){
                        return CircularProgressIndicator();
                      }
                      if(cities == null){
                        return Text('Loading Cities');
                      }
                      return ListView.builder(
                        itemCount: cities!.length,
                        itemBuilder: (context,index){
                          city = cities![index];
                          var weatherData = weatherService.cityWeatherData[city];
                          return ListTile(
                            title: Text(city!),
                            subtitle: Text(
                              weatherData != null
                                  ? '${weatherData['condition']}  ${weatherData['temp']}°C'
                                  : 'Data not available',
                            ),
                            onTap: (){
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (context) => Weatherpage(username: widget.username,location: cities![index],isFav: true,))
                                );
                            },
                          );
                        }
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
