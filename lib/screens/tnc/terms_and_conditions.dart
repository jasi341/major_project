import 'package:flutter/material.dart';

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
            children: const [
              Text(
                'Terms of Use',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Acceptance of Terms:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'By using this chat app, you agree to comply with the following terms of use.',
              ),
              SizedBox(height: 16),
              Text(
                '2. User Conduct:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Users are expected to behave responsibly and respectfully while using the chat app. Prohibited actions include...',
              ),
              SizedBox(height: 16),
              Text(
                '3. Privacy Policy:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'We respect your privacy and handle your personal information in accordance with our privacy policy. Please review our privacy policy for more details.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Intellectual Property:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'All intellectual property rights associated with the chat app, including trademarks, logos, and content, are owned by the app developers.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Prohibited Content:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Users are not allowed to post or share any content that is illegal, abusive, or violates the rights of others.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Account Suspension:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The app administrators reserve the right to suspend or terminate user accounts for violating the terms of use or engaging in inappropriate behavior.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Limitation of Liability:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The app developers are not liable for any damages or losses incurred while using the chat app.',
              ),
              SizedBox(height: 16),
              Text(
                '8. Changes to Terms of Use:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The app developers may modify or update the terms of use at any time. Users will be notified of any changes.',
              ),
              SizedBox(height: 16),
              Text(
                '9. Governing Law:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The terms of use are governed by and interpreted in accordance with the laws of India(In).',
              ),
              SizedBox(height: 16),
              Text(
                '10. Contact Information:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'For inquiries, feedback, or reporting violations, users can contact the app administrators via given Email address : skuly633@gmail.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
