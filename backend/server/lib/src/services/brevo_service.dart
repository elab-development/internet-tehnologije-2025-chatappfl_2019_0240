import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

class BrevoService {
  final String apiKey;
  final String senderName;
  final String senderEmail;

  BrevoService({
    required this.apiKey,
    required this.senderName,
    required this.senderEmail,
  });

  Future<bool> sendVerificationEmail(
    Session session, {
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.brevo.com/v3/smtp/email'),
        headers: {
          'api-key': apiKey,
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          'sender': {'name': senderName, 'email': senderEmail},
          'to': [
            {'email': email}
          ],
          'subject': 'Tvoj kod za Lasta 493',
          'htmlContent': '''
            <div style="font-family: Arial, sans-serif; padding: 20px; border: 1px solid #eee; border-radius: 10px;">
              <h2 style="color: #E31212;">Dobrodošli u Lasta 493! 🚌</h2>
              <p>Tvoj verifikacioni kod je:</p>
              <div style="background-color: #F6FA0B; padding: 20px; font-size: 32px; font-weight: bold; text-align: center; border-radius: 5px; color: #E31212; letter-spacing: 5px;">
                $code
              </div>
              <p>Unesi ovaj kod u aplikaciju da potvrdiš svoj nalog.</p>
              <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
              <p style="font-size: 12px; color: #777;">Ako niste tražili ovaj kod, možete slobodno ignorisati ovaj mejl.</p>
            </div>
          ''',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        session.log('Brevo: Email uspešno poslat na $email', level: LogLevel.info);
        return true;
      } else {
        session.log(
          'Brevo GREŠKA: Slanje nije uspelo za $email. Status: ${response.statusCode}, Body: ${response.body}',
          level: LogLevel.error,
        );
        return false;
      }
    } catch (e, stackTrace) {
      session.log(
        'Brevo KRITIČNA GREŠKA pri slanju na $email: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
