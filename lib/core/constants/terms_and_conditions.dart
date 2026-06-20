class TermsSection {
  const TermsSection({required this.title, required this.body});

  final String title;
  final String body;
}

class TermsAndConditions {
  static const lastUpdated = 'June 2026';

  static const sections = <TermsSection>[
    TermsSection(
      title: '1. Acceptance of Terms',
      body:
          'By creating an account or using Eaze.me, you agree to these Terms & '
          'Conditions and our Privacy Policy. If you do not agree, please do '
          'not use the platform.',
    ),
    TermsSection(
      title: '2. About Eaze.me',
      body:
          'Eaze.me connects customers with independent service professionals '
          '(such as electricians, plumbers, cleaners, and technicians). '
          'Eaze.me facilitates bookings and communication but does not directly '
          'perform the services unless explicitly stated.',
    ),
    TermsSection(
      title: '3. Account Registration',
      body:
          'You must provide accurate, complete, and current information when '
          'registering. You are responsible for safeguarding your login '
          'credentials and for all activity that occurs under your account.',
    ),
    TermsSection(
      title: '4. Bookings & Payments',
      body:
          'Service availability, pricing, and completion timelines may vary by '
          'professional and location. Payments, cancellations, and refunds are '
          'handled according to the booking details shown at checkout and any '
          'applicable cancellation policy.',
    ),
    TermsSection(
      title: '5. User Conduct',
      body:
          'You agree not to misuse the platform, harass others, post unlawful '
          'content, attempt unauthorized access, or interfere with the normal '
          'operation of Eaze.me. We may suspend or terminate accounts that '
          'violate these rules.',
    ),
    TermsSection(
      title: '6. Professional Services',
      body:
          'Professionals listed on Eaze.me are independent providers. Eaze.me '
          'does not guarantee the quality, safety, or legality of services '
          'performed. Customers should verify credentials where required and '
          'report concerns through the app.',
    ),
    TermsSection(
      title: '7. Liability',
      body:
          'To the fullest extent permitted by law, Eaze.me is not liable for '
          'indirect, incidental, or consequential damages arising from your use '
          'of the platform or from services arranged through it.',
    ),
    TermsSection(
      title: '8. Changes to These Terms',
      body:
          'We may update these Terms & Conditions from time to time. Continued '
          'use of Eaze.me after changes become effective constitutes acceptance '
          'of the revised terms.',
    ),
    TermsSection(
      title: '9. Contact',
      body:
          'For questions about these Terms & Conditions, contact us at '
          'support@eaze.me.',
    ),
  ];
}
