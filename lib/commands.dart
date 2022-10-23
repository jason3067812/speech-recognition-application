import 'dart:convert';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

class Command {
  static final commands = [
    email,
    browser,
    launchUrl,
    displayOn,
    displayOff,
    displayTime,
    displayMessage,

  ];

  static const email = 'write email', browser = 'open', launchUrl = 'go to', displayOn = 'display on', displayOff = 'display off', displayTime = 'display time', displayMessage = 'display message';
}

class Utils {
  static String _executeCommand({
    required String text,
    required String command,
  }) {
    final commandIndex = text.indexOf(command);
    final finalIndex = commandIndex + command.length;

    if (commandIndex == -1) {
      return '';
    } else {
      return text.substring(finalIndex).trim();
    }
  }

  static Future _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  static Future openEmail(String body) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }

  static Future openLink(String url) async {
    if (url.trim().isEmpty) {
      await _launchUrl('https://google.com');
    } else {
      await _launchUrl('https://$url');
    }
  }

  static Future<http.Response> createAlbum(String title) async {
    return http.post(
      Uri.parse('https://89d3-160-39-179-18.ngrok.io/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'command': title
      }),
    );
  }

  static void scanVoicedText(String voicedText) {
    final text = voicedText.toLowerCase();

    if (text.contains(Command.email)) {
      final body = _executeCommand(text: text, command: Command.email);
      openEmail(body);

    } else if (text.contains(Command.browser)) {
      final url1 = _executeCommand(text: text, command: Command.browser);
      openLink(url1);

    } else if (text.contains(Command.displayOn)) {
      final url2 = _executeCommand(text: text, command: Command.displayOn);
      createAlbum("display on");

    } else if (text.contains(Command.displayOff)) {
      createAlbum("display off");
    }
    else if (text.contains(Command.displayTime)) {
      createAlbum("display time");
    }
    else if (text.contains(Command.displayMessage)) {
      final url3 = _executeCommand(text: text, command: Command.displayMessage);
      createAlbum("display message" + " " + url3);
    }
  }
}