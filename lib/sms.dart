/*import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class SMSService {
  static final Telephony telephony = Telephony.instance;

  static Future<void> sendSMS(String phoneNumber, String message) async {
    try {
      await telephony.sendSms(
        to: phoneNumber,
        message: message,
      );
      print('SMS sent successfully');
    } catch (e) {
      print('Failed to send SMS: $e');
      print("sms function entered\n msg sent function");
    }
  }
}
*/