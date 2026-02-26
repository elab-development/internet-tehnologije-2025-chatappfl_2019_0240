import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

class MailService {
  final String apiKey;

  MailService({required this.apiKey});

  Future<bool> sendVerificationEmail(
    Session session, {
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.resend.com/emails'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': 'Chat 493 <onboarding@resend.dev>', // You should update this with your domain once verified in Resend
          'to': [email],
          'subject': 'Your Verification Code',
          'html': '''
            <div style="font-family: Arial, sans-serif; padding: 20px;">
              <h2>Welcome to Chat 493!</h2>
              <p>Your verification code is:</p>
              <div style="background-color: #f4f4f4; padding: 15px; font-size: 24px; font-weight: bold; text-align: center; border-radius: 5px; color: #333;">
                $code
              </div>
              <p>Please enter this code in the app to complete your registration.</p>
              <p>If you didn't request this code, you can safely ignore this email.</p>
            </div>
          ''',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        session.log('Email sent successfully to $email', level: LogLevel.info);
        return true;
      } else {
        session.log(
          'Failed to send email to $email. Status: ${response.statusCode}, Body: ${response.body}',
          level: LogLevel.error,
        );
        return false;
      }
    } catch (e, stackTrace) {
      session.log(
        'Error sending email to $email: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
