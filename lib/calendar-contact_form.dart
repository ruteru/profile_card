import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
final clientId = dotenv.env['GOOGLE_CLIENT_ID'];
final clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET'];

Future<void> createCalendarEvent(String accessToken) async {
  final client = http.Client();
  final credentials = auth.AccessCredentials(
    auth.AccessToken(accessToken, null),
    null, // Refresh token
    ['https://www.googleapis.com/auth/calendar'], // Scopes
  );

  final calendarApi = calendar.CalendarApi(client);

  final event = calendar.Event()
    ..summary = 'Appointment'
    ..description = 'Meeting with a client'
    ..start = calendar.EventDateTime.dateTime(DateTime.now().add(Duration(hours: 1)))
    ..end = calendar.EventDateTime.dateTime(DateTime.now().add(Duration(hours: 2)));

  try {
    await calendarApi.events.insert(event, 'primary');
    print('Event created successfully.');
  } catch (e) {
    print('Error creating event: $e');
  } finally {
    client.close();
  }
}
