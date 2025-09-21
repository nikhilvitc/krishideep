import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('contact_support'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.contact_support,
                          size: 48,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'contact_us'.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Get in touch with our agricultural experts for personalized support',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Emergency Helpline
                Card(
                  color: Colors.red.shade50,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emergency,
                          color: Colors.red.shade700,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Helpline',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '24/7 support for urgent farming issues',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '1800-180-1551',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _makePhoneCall('1800-180-1551'),
                          icon: Icon(Icons.phone, color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Contact Methods
                _buildContactCard(
                  'Customer Support',
                  'General queries and support',
                  Icons.headset_mic,
                  Colors.blue,
                  [
                    ContactInfo('Phone', '+91-11-2338-9713', Icons.phone),
                    ContactInfo(
                      'Email',
                      'support@sihcropadvisor.gov.in',
                      Icons.email,
                    ),
                    ContactInfo(
                      'Working Hours',
                      'Mon-Fri: 9:00 AM - 6:00 PM',
                      Icons.schedule,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildContactCard(
                  'Technical Support',
                  'App-related issues and feedback',
                  Icons.build,
                  Colors.orange,
                  [
                    ContactInfo('Phone', '+91-11-2338-9714', Icons.phone),
                    ContactInfo(
                      'Email',
                      'tech@sihcropadvisor.gov.in',
                      Icons.email,
                    ),
                    ContactInfo('WhatsApp', '+91-98765-43210', Icons.chat),
                  ],
                ),

                const SizedBox(height: 16),

                _buildContactCard(
                  'Agricultural Experts',
                  'Expert advice and consultation',
                  Icons.psychology,
                  Colors.green,
                  [
                    ContactInfo(
                      'Dr. Rajesh Kumar',
                      'Crop Specialist',
                      Icons.person,
                    ),
                    ContactInfo(
                      'Dr. Priya Singh',
                      'Soil Health Expert',
                      Icons.person,
                    ),
                    ContactInfo(
                      'Prof. Amit Sharma',
                      'Plant Pathologist',
                      Icons.person,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Regional Offices
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.purple.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Regional Offices',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _buildOfficeInfo(
                          'North Region',
                          'New Delhi',
                          '+91-11-2338-9715',
                        ),
                        const Divider(),
                        _buildOfficeInfo(
                          'South Region',
                          'Hyderabad',
                          '+91-40-6678-9012',
                        ),
                        const Divider(),
                        _buildOfficeInfo(
                          'West Region',
                          'Mumbai',
                          '+91-22-2567-8901',
                        ),
                        const Divider(),
                        _buildOfficeInfo(
                          'East Region',
                          'Kolkata',
                          '+91-33-2456-7890',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Social Media & Feedback
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Open feedback form
                        },
                        icon: const Icon(Icons.feedback),
                        label: const Text('Send Feedback'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Rate app
                        },
                        icon: const Icon(Icons.star),
                        label: const Text('Rate App'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Social Media Links
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Follow Us',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSocialButton(
                              Icons.facebook,
                              'Facebook',
                              Colors.blue.shade800,
                            ),
                            _buildSocialButton(
                              Icons.camera_alt,
                              'Instagram',
                              Colors.purple.shade600,
                            ),
                            _buildSocialButton(
                              Icons.alternate_email,
                              'Twitter',
                              Colors.blue.shade400,
                            ),
                            _buildSocialButton(
                              Icons.video_library,
                              'YouTube',
                              Colors.red.shade600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    List<ContactInfo> contacts,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ...contacts.map(
              (contact) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(contact.icon, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            contact.value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    if (contact.icon == Icons.phone ||
                        contact.icon == Icons.chat)
                      IconButton(
                        onPressed: () => _makePhoneCall(contact.value),
                        icon: Icon(Icons.call, color: color),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    if (contact.icon == Icons.email)
                      IconButton(
                        onPressed: () => _sendEmail(contact.value),
                        icon: Icon(Icons.mail, color: color),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficeInfo(String region, String city, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  region,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  city,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(phone, style: const TextStyle(fontSize: 14)),
          IconButton(
            onPressed: () => _makePhoneCall(phone),
            icon: Icon(Icons.call, color: Colors.purple.shade700),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // In a real app, you would use url_launcher package
    // launch('tel:$phoneNumber');
    print('Calling $phoneNumber');
  }

  void _sendEmail(String email) {
    // In a real app, you would use url_launcher package
    // launch('mailto:$email');
    print('Sending email to $email');
  }
}

class ContactInfo {
  final String label;
  final String value;
  final IconData icon;

  ContactInfo(this.label, this.value, this.icon);
}
