import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData weatherState;
  const HourlyForecastItem(
      {super.key,
      required this.time,
      required this.temperature,
      required this.weatherState});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white12,
      child: Container(
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Icon(weatherState),
            const SizedBox(height: 8),
            Text(
              temperature,
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
