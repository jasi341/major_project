import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';


class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terms of Use',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Acceptance of Terms:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'By using this chat app, you agree to comply with the following terms of use.',
              ),
              const SizedBox(height: 16),
              const Text(
                '2. User Conduct:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Users are expected to behave responsibly and respectfully while using the chat app. Prohibited actions include...',
              ),
              const SizedBox(height: 16),
              const Text(
                '3. Privacy Policy:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'We respect your privacy and handle your personal information in accordance with our privacy policy. Please review our privacy policy for more details.',
              ),
              const SizedBox(height: 16),
              const Text(
                '4. Intellectual Property:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'All intellectual property rights associated with the chat app, including trademarks, logos, and content, are owned by the app developers.',
              ),
              const SizedBox(height: 16),
              const Text(
                '5. Prohibited Content:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Users are not allowed to post or share any content that is illegal, abusive, or violates the rights of others.',
              ),
              const SizedBox(height: 16),
              const Text(
                '6. Account Suspension:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'The app administrators reserve the right to suspend or terminate user accounts for violating the terms of use or engaging in inappropriate behavior.',
              ),
              const SizedBox(height: 16),
              const Text(
                '7. Limitation of Liability:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'The app developers are not liable for any damages or losses incurred while using the chat app.',
              ),
              const SizedBox(height: 16),
              const Text(
                '8. Changes to Terms of Use:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'The app developers may modify or update the terms of use at any time. Users will be notified of any changes.',
              ),
              const SizedBox(height: 16),
              const Text(
                '9. Governing Law:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'The terms of use are governed by and interpreted in accordance with the laws of India(In).',
              ),
              const SizedBox(height: 16),
              const Text(
                '10. Contact Information:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'For inquiries, feedback, or reporting violations,\n users can contact the app administrators via given ',
              ),

              Row(
                children: [
                  const Text(
                    'Email: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _launchEmail('skuly633@gmail.com');
                      //
                    },
                    child: const Text(
                      'skuly633@gmail.com',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _launchEmail(String emailId) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailId,
    );

    try {
      await launch(emailLaunchUri.toString());
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error launching email: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      final Uri webLaunchUri = Uri(
        scheme: 'https',
        host: 'mail.google.com',
        path: '/mail/u/0/?view=cm&fs=1&tf=1',
        queryParameters: {'to': emailId},
      );
      await launch(webLaunchUri.toString());
    }
  }
}

