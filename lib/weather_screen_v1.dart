import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/addition_info.dart';
import 'package:weather_app/hourly_forecast_item.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

// 14:XX:XX CHECKPOINT

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late double temp = 0;
  bool isLoading = true;
  late String weatherType = '';

  @override
  void initState() {
    super.initState();
    try {
      getCurrentWeather();
    } catch (e) {
      print(e);
    }
  }

  Future getCurrentWeather() async {
    try {
      String latitude = '5.6436';
      String longitude = '100.4894';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpectd error occured';
      }

      setState(() {
        temp = data['list'][0]['main']['temp'] - 273.15;
        // temp = temp;
        // temp = data['list'][0]['main']['temp'];
        isLoading = false;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          //? FIRST METHOD (THIS IS MORE ADVANCE)
          // InkWell(
          //   onTap: () {
          //     print('refresh');
          //   },
          //   child: const Icon(Icons.refresh_rounded),
          // )

          //? SECOND METHOD (THIS IS LESS ADVANCE)
          // GestureDetector(
          //   onTap: () {
          //     print('awdawdaw');
          //   },
          //   child: const Icon(Icons.refresh_rounded),
          // )

          //?THIRD METHOD
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* main card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Center(
                            child: isLoading
                                ? const LinearProgressIndicator()
                                : Text(
                                    temp != 0
                                        ? '${temp.toStringAsFixed(2)} °C'
                                        : '0.00',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 15),
                          isLoading
                              ? const SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator(),
                                )
                              : const Icon(
                                  Icons.cloud,
                                  size: 70,
                                ),
                          const SizedBox(height: 15),
                          isLoading
                              ? const LinearProgressIndicator()
                              : const Text(
                                  'Rain',
                                  style: TextStyle(fontSize: 20),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //* Weather Forecast Cards =====================================
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Weather Forecast',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecastItem(
                    time: '09:00',
                    weatherState: Icons.cloud,
                    temperature: '35.3',
                  ),
                  HourlyForecastItem(
                    time: '10:00',
                    weatherState: Icons.thunderstorm,
                    temperature: '35.3',
                  ),
                  HourlyForecastItem(
                    time: '11:00',
                    weatherState: Icons.sunny,
                    temperature: '35.3',
                  ),
                  HourlyForecastItem(
                    time: '12:00',
                    weatherState: Icons.sunny,
                    temperature: '35.3',
                  ),
                  HourlyForecastItem(
                    time: '13:00',
                    weatherState: Icons.snowing,
                    temperature: '35.3',
                  )
                ],
              ),
            ),
            //* Additional Information =================================
            const Text(
              'Additional Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInformation(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '94',
                ),
                AdditionalInformation(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '7.5',
                ),
                AdditionalInformation(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1000',
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
