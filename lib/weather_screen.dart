import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/addition_info.dart';
import 'package:weather_app/hourly_forecast_item.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

//TODO PLEASE REEWATCH 16:00:00

//? THIS USE FUTURE BUILDER METHOD INSTEAD OF MANUALLY INTEGRATING LOADING

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late double temp = 0;
  // bool isLoading = true;
  // late String weatherType = '';

  // @override
  // void initState() {
  //   super.initState();
  //   try {
  //     getCurrentWeather();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String latitude = '5.6436';
      String longitude = '100.4894';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        // throw 'An unexpectd error occured';
        throw data['message'];
      }

      return data;

      // setState(() {
      //   temp = data['list'][0]['main']['temp'] - 273.15;
      //   // temp = temp;
      //   // temp = data['list'][0]['main']['temp'];
      //   isLoading = false;
      // });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
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
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          // print(snapshot);
          // print(snapshot.runtimeType);
          // print(context);
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'] - 273.15;
          final currentSky = currentWeatherData['weather'][0]['main'];

          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          return Padding(
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
                                child:
                                    // isLoading ? const LinearProgressIndicator():
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? const LinearProgressIndicator()
                                        : Text(
                                            currentTemp != 0
                                                ? '${currentTemp.toStringAsFixed(2)} °C'
                                                : '0.00',
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                              ),
                              const SizedBox(height: 15),
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  // isLoading
                                  ? const SizedBox(
                                      height: 70,
                                      width: 70,
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    )
                                  : Icon(
                                      currentSky == 'Clouds'
                                          ? Icons.cloud
                                          : currentSky == 'Rain'
                                              ? Icons.grain
                                              : currentSky == 'Thunderstorm'
                                                  ? Icons.thunderstorm_sharp
                                                  : currentSky == 'Drizzle'
                                                      ? Icons.water_damage_sharp
                                                      : currentSky == 'Snow'
                                                          ? Icons.cloudy_snowing
                                                          : Icons.sunny,
                                      size: 70,
                                    ),
                              const SizedBox(height: 15),
                              // isLoading
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const LinearProgressIndicator()
                                  : Text(
                                      currentSky,
                                      style: const TextStyle(fontSize: 20),
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
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 5; i++)
                //         HourlyForecast(
                //           time: data['list'][i + 1]['dt'].toString(),
                //           weatherState: data['list'][i + 1]['weather'][0]
                //                       ['main'] ==
                //                   'Clouds'
                //               ? Icons.cloud
                //               : data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //                   ? Icons.grain
                //                   : data['list'][i + 1]['weather'][0]['main'] ==
                //                           'Thunderstorm'
                //                       ? Icons.thunderstorm_sharp
                //                       : data['list'][i + 1]['weather'][0]
                //                                   ['main'] ==
                //                               'Drizzle'
                //                           ? Icons.water_damage_sharp
                //                           : data['list'][i + 1]['weather'][0]
                //                                       ['main'] ==
                //                                   'Snow'
                //                               ? Icons.cloudy_snowing
                //                               : Icons.sunny,
                //           temperature:
                //               (data['list'][i + 1]['main']['temp'] - 273.15)
                //                   .toStringAsFixed(2),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final hourlyTemp =
                            hourlyForecast['main']['temp'] - 273.15;
                        final time = hourlyForecast['dt_txt'] != null
                            ? DateTime.parse(hourlyForecast['dt_txt'])
                            : DateTime.now();
                            
                        return HourlyForecastItem(
                            time: DateFormat.j().format(time),
                            weatherState: hourlySky == 'Clouds'
                                ? Icons.cloud
                                : hourlySky == 'Rain'
                                    ? Icons.grain
                                    : hourlySky == 'Thunderstorm'
                                        ? Icons.thunderstorm_sharp
                                        : hourlySky == 'Drizzle'
                                            ? Icons.water_damage_sharp
                                            : hourlySky == 'Snow'
                                                ? Icons.cloudy_snowing
                                                : Icons.sunny,
                            temperature: hourlyTemp.toStringAsFixed(2));
                      }),
                ),
                //* Additional Information =================================
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${currentHumidity.toString()} %rh',
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '${currentWindSpeed.toString()} m/s',
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '${currentPressure.toString()} Hg',
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
