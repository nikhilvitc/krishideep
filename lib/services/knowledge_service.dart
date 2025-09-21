import '../models/faq.dart';

class KnowledgeService {
  // Dummy FAQ data
  static final List<FAQ> _faqs = [
    FAQ(
      id: '1',
      question: 'What is the best time to plant crops?',
      questionHindi: 'फसल बोने का सबसे अच्छा समय कौन सा है?',
      answer:
          'The best time to plant crops depends on the crop type and local climate. Generally, Kharif crops are planted during monsoon season (June-July), and Rabi crops are planted in winter season (November-December).',
      answerHindi:
          'फसल बोने का सबसे अच्छा समय फसल के प्रकार और स्थानीय जलवायु पर निर्भर करता है। आमतौर पर, खरीफ फसलें मानसून के मौसम में (जून-जुलाई) और रबी फसलें सर्दियों के मौसम में (नवंबर-दिसंबर) बोई जाती हैं।',
      category: 'General',
    ),
    FAQ(
      id: '2',
      question: 'How do I test my soil pH?',
      questionHindi: 'मैं अपनी मिट्टी का pH कैसे जांच सकता हूं?',
      answer:
          'You can test soil pH using pH test strips, digital pH meters, or by taking soil samples to agricultural testing laboratories. Most crops prefer slightly acidic to neutral pH (6.0-7.5).',
      answerHindi:
          'आप pH टेस्ट स्ट्रिप्स, डिजिटल pH मीटर का उपयोग करके या मिट्टी के नमूने कृषि परीक्षण प्रयोगशालाओं में भेजकर मिट्टी का pH जांच सकते हैं। अधिकांश फसलें हल्की अम्लीय से तटस्थ pH (6.0-7.5) पसंद करती हैं।',
      category: 'Soil Management',
    ),
    FAQ(
      id: '3',
      question: 'What are the signs of nutrient deficiency in crops?',
      questionHindi: 'फसलों में पोषक तत्वों की कमी के लक्षण क्या हैं?',
      answer:
          'Common signs include yellowing of leaves (nitrogen deficiency), purple leaves (phosphorus deficiency), brown leaf edges (potassium deficiency), and stunted growth. Visual inspection and soil testing can help identify specific deficiencies.',
      answerHindi:
          'सामान्य लक्षणों में पत्तियों का पीला होना (नाइट्रोजन की कमी), बैंगनी पत्तियां (फास्फोरस की कमी), पत्तियों के किनारे भूरे होना (पोटैशियम की कमी), और वृद्धि रुकना शामिल है। दृश्य निरीक्षण और मिट्टी परीक्षण से विशिष्ट कमियों की पहचान की जा सकती है।',
      category: 'Crop Health',
    ),
    FAQ(
      id: '4',
      question: 'How often should I water my crops?',
      questionHindi: 'मुझे अपनी फसलों को कितनी बार पानी देना चाहिए?',
      answer:
          'Watering frequency depends on crop type, soil type, weather conditions, and growth stage. Generally, deep watering 2-3 times per week is better than daily shallow watering. Monitor soil moisture and adjust accordingly.',
      answerHindi:
          'पानी देने की आवृत्ति फसल के प्रकार, मिट्टी के प्रकार, मौसम की स्थिति और वृद्धि के चरण पर निर्भर करती है। आमतौर पर, सप्ताह में 2-3 बार गहरा पानी देना दैनिक उथले पानी से बेहतर है। मिट्टी की नमी की निगरानी करें और तदनुसार समायोजित करें।',
      category: 'Irrigation',
    ),
    FAQ(
      id: '5',
      question: 'What are organic farming practices?',
      questionHindi: 'जैविक खेती की प्रथाएं क्या हैं?',
      answer:
          'Organic farming involves using natural fertilizers (compost, manure), biological pest control, crop rotation, and avoiding synthetic chemicals. It focuses on soil health, biodiversity, and sustainable practices.',
      answerHindi:
          'जैविक खेती में प्राकृतिक उर्वरकों (खाद, गोबर) का उपयोग, जैविक कीट नियंत्रण, फसल चक्र, और कृत्रिम रसायनों से बचना शामिल है। यह मिट्टी के स्वास्थ्य, जैव विविधता और टिकाऊ प्रथाओं पर केंद्रित है।',
      category: 'Sustainable Farming',
    ),
    FAQ(
      id: '6',
      question: 'How can I prevent crop diseases?',
      questionHindi: 'मैं फसल रोगों को कैसे रोक सकता हूं?',
      answer:
          'Prevention strategies include using disease-resistant varieties, proper crop rotation, maintaining field hygiene, ensuring good air circulation, avoiding overwatering, and regular monitoring for early detection.',
      answerHindi:
          'रोकथाम की रणनीतियों में रोग-प्रतिरोधी किस्मों का उपयोग, उचित फसल चक्र, खेत की स्वच्छता बनाए रखना, अच्छी हवा का संचार सुनिश्चित करना, अधिक पानी से बचना, और शीघ्र पहचान के लिए नियमित निगरानी शामिल है।',
      category: 'Disease Management',
    ),
  ];

  // Get all FAQs
  List<FAQ> getAllFAQs() {
    return _faqs;
  }

  // Get FAQs by category
  List<FAQ> getFAQsByCategory(String category) {
    return _faqs.where((faq) => faq.category == category).toList();
  }

  // Search FAQs
  List<FAQ> searchFAQs(String query) {
    return _faqs
        .where(
          (faq) =>
              faq.question.toLowerCase().contains(query.toLowerCase()) ||
              faq.questionHindi.contains(query) ||
              faq.answer.toLowerCase().contains(query.toLowerCase()) ||
              faq.answerHindi.contains(query),
        )
        .toList();
  }

  // Get unique categories
  List<String> getCategories() {
    return _faqs.map((faq) => faq.category).toSet().toList();
  }

  // Get farming guidelines
  Map<String, List<String>> getFarmingGuidelines() {
    return {
      'Soil Preparation': [
        'Test soil pH and nutrient levels',
        'Add organic matter to improve soil structure',
        'Ensure proper drainage',
        'Remove weeds and crop residues',
        'Deep plowing before planting',
      ],
      'Seed Selection': [
        'Choose high-quality certified seeds',
        'Select varieties suitable for local climate',
        'Consider disease-resistant varieties',
        'Check seed germination rate',
        'Treat seeds if necessary',
      ],
      'Planting': [
        'Follow recommended planting dates',
        'Maintain proper spacing between plants',
        'Plant at appropriate depth',
        'Ensure good seed-to-soil contact',
        'Water immediately after planting',
      ],
      'Fertilization': [
        'Apply basal fertilizers before planting',
        'Follow recommended NPK ratios',
        'Use organic fertilizers when possible',
        'Apply nutrients based on soil test results',
        'Time fertilizer applications properly',
      ],
      'Irrigation': [
        'Water at appropriate growth stages',
        'Maintain consistent soil moisture',
        'Use efficient irrigation methods',
        'Avoid waterlogging',
        'Monitor weather conditions',
      ],
      'Pest Management': [
        'Regular monitoring for pests',
        'Use integrated pest management (IPM)',
        'Apply pesticides only when necessary',
        'Follow safety guidelines',
        'Encourage beneficial insects',
      ],
    };
  }
}
