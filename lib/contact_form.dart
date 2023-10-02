import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:flutter_google_auth/flutter_google_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_calendar/flutter_google_calendar.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
final clientId = dotenv.env['GOOGLE_CLIENT_ID'];
final clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET'];

class ContactFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Form'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Future<void> createEvent(DateTime startTime, DateTime endTime, String summary) async {
  final calendarApi = calendar.CalendarApi(_credentials);

  final event = calendar.Event()
    ..summary = summary
    ..start = calendar.EventDateTime.dateTime(startTime)
    ..end = calendar.EventDateTime.dateTime(endTime);

  await calendarApi.events.insert(event, 'clientId');
}
Future<List<DateTime>> fetchAvailableDates() async {
  final calendarApi = calendar.CalendarApi(_credentials);

  final now = DateTime.now();
  final endDate = now.add(Duration(days: 30)); // Fetch dates for the next 30 days
  final events = await calendarApi.events.list('clientId',
      timeMin: now.toUtc(),
      timeMax: endDate.toUtc(),
      singleEvents: true,
      orderBy: 'startTime');

  final availableDates = events.items.map((event) {
    final start = event.start.dateTime.toLocal();
    final end = event.end.dateTime.toLocal();
    // Check if the event is available (e.g., no existing appointments)
    if (start.isBefore(end)) {
      return start;
    }
    return null;
  }).where((date) => date != null).toList();

  return availableDates;
}

          ],
        ),
      ),
    );
  }
}

void main() async {
  // Crea una instancia de la clase CalendarClient
  final client = CalendarClient(
    // Copia el código OAuth 2.0 que obtuviste en el paso 3
    credentials: OAuthCredentials(
      clientId: "Tu código OAuth 2.0",
      clientSecret: "Tu código OAuth 2.0",
    ),
  );

  // Obtén una lista de eventos del calendario
  final events = await client.events();

  // Imprime la lista de eventos
  events.forEach((event) {
    print(event.summary);
  });
}