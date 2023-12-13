import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController _cityController = TextEditingController();
  String _apiKey = "f70ac09683bb927655626a52dae57c38"; // Replace with your OpenWeatherMap API key
  String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  String _cityName = "";
  double _temperature = 0.0;
  String _weatherCondition = "";
  double _windSpeed = 0.0;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Enter City',
                border: OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid,color: Colors.black12)
                ),
                hintText: ""),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _fetchWeatherData();
                },
                child: Text('Get Weather'),
              ),
              SizedBox(height: 16.0),
              _loading
                  ? CircularProgressIndicator()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(style: BorderStyle.solid),
                          right: BorderSide(style: BorderStyle.solid),
                          bottom:BorderSide(style: BorderStyle.solid),
                          top: BorderSide(style: BorderStyle.solid)
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('City: $_cityName'),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(style: BorderStyle.solid),
                          right: BorderSide(style: BorderStyle.solid),
                          bottom:BorderSide(style: BorderStyle.solid),
                          top: BorderSide(style: BorderStyle.solid)
                      )
                  ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Temperature: $_temperature °C'),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(style: BorderStyle.solid),
                              right: BorderSide(style: BorderStyle.solid),
                              bottom:BorderSide(style: BorderStyle.solid),
                              top: BorderSide(style: BorderStyle.solid)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Condition: $_weatherCondition'),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(style: BorderStyle.solid),
                              right: BorderSide(style: BorderStyle.solid),
                              bottom:BorderSide(style: BorderStyle.solid),
                              top: BorderSide(style: BorderStyle.solid)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Wind Speed: $_windSpeed m/s'),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _loading = true;
    });

    try {
      Uri url=Uri.parse( '$_baseUrl?q=${_cityController.text}&appid=$_apiKey&units=metric');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _cityName = data['name'];
          _temperature = data['main']['temp'];
          _weatherCondition = data['weather'][0]['description'];
          _windSpeed = data['wind']['speed'];
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
