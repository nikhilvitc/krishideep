# SIH Crop Advisor - Flutter Mobile App

A comprehensive Flutter mobile application developed for the Smart India Hackathon, focusing on **AI-Based Crop Recommendation for Farmers**.

## 🌱 Features

### Core Features
- **OTP-Based Authentication** using Firebase
- **Multilingual Support** (English & Hindi) with easy_localization
- **AI-Powered Crop Recommendations** based on soil conditions
- **Crop Disease Detection** using camera/image upload
- **Knowledge Base & FAQs** with expandable sections
- **Expert Contact Support** with helpline numbers
- **Light/Dark Theme Support**
- **Responsive UI Design**

### Technical Features
- Provider state management
- Firebase Authentication integration
- Dummy ML model integration (ready for TensorFlow Lite)
- Location services with auto-detection
- Image picker for disease detection
- Multi-language translation support
- Clean architecture with proper folder structure

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── crop.dart
│   ├── crop_advice.dart
│   ├── crop_recommendation.dart
│   ├── disease_detection.dart
│   └── faq.dart
├── screens/                  # UI screens
│   ├── login_screen.dart
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── crop_advice_screen.dart
│   ├── crop_result_screen.dart
│   ├── disease_detection_screen.dart
│   ├── knowledge_screen.dart
│   └── contact_screen.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── crop_service.dart
│   ├── knowledge_service.dart
│   └── location_service.dart
├── themes/                   # App theming
│   └── app_theme.dart
└── widgets/                  # Reusable widgets
    └── common_widgets.dart

assets/
└── translations/             # Localization files
    ├── en.json
    └── hi.json
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Android Studio / VS Code
- Firebase project (for authentication)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sih-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Enable Authentication with Phone provider
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in appropriate folders

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Screens

### 1. Authentication
- **Login Screen**: Phone number input with OTP verification
- **Language Selection**: Switch between English and Hindi

### 2. Home Dashboard
- **Welcome Section**: User greeting and app overview
- **Feature Cards**: Quick access to main features
- **Statistics**: App usage metrics

### 3. Crop Advice
- **Input Form**: Soil pH, moisture, farm size, location
- **Location Detection**: Auto-detect current location
- **Results Screen**: Recommended crops with yield and profit data

### 4. Disease Detection
- **Image Capture**: Camera or gallery image selection
- **AI Analysis**: Mock ML model processing
- **Results Display**: Disease identification with treatment suggestions

### 5. Knowledge Base
- **FAQ Section**: Searchable and categorized questions
- **Guidelines**: Farming best practices in expandable format
- **Multi-language**: Content available in English and Hindi

### 6. Contact Support
- **Emergency Helpline**: 24/7 support numbers
- **Expert Contacts**: Specialized agricultural consultants
- **Regional Offices**: Location-based support centers

## 🛠️ Technical Implementation

### State Management
- **Provider**: Used for theme and authentication state
- **Consumer Widgets**: Reactive UI updates

### API Integration
- **Dummy Services**: Mock implementations for demonstration
- **Future-Ready**: Easy integration with real APIs and ML models

### Firebase Features
- **Phone Authentication**: OTP-based login
- **Error Handling**: Comprehensive error management

### Localization
- **easy_localization**: Seamless language switching
- **Translation Files**: JSON-based translation system

### UI/UX Features
- **Material Design 3**: Modern UI components
- **Animations**: Smooth transitions and loading states
- **Responsive Layout**: Adaptive design for different screen sizes

## 📋 Demo Flow

### Login Process
1. Enter phone number (+91 format)
2. Receive OTP (use `123456` for demo)
3. Verify and access main app

### Getting Crop Advice
1. Navigate to "Get Crop Advice"
2. Fill soil conditions (pH: 6-8, Moisture: 30-70%)
3. Add farm size and location
4. View AI-generated recommendations

### Disease Detection
1. Go to "Crop Disease Detection"
2. Take photo or upload from gallery
3. Wait for analysis (3 seconds mock processing)
4. View results with treatment advice

## 🔧 Configuration

### Environment Setup
- **Minimum SDK**: Flutter 3.0
- **Target Platforms**: Android & iOS
- **Permissions Required**: Camera, Location, Internet

### Customization
- **Themes**: Modify `lib/themes/app_theme.dart`
- **Colors**: Update primary colors in theme file
- **Translations**: Edit JSON files in `assets/translations/`
- **Dummy Data**: Modify service files for custom data

## 📚 Dependencies

```yaml
dependencies:
  flutter: ^3.x
  provider: ^6.0.5
  firebase_core: ^2.15.1
  firebase_auth: ^4.9.0
  easy_localization: ^3.0.3
  geolocator: ^10.1.0
  image_picker: ^1.0.4
  http: ^1.1.0
  shared_preferences: ^2.2.2
  flutter_staggered_animations: ^1.1.1
```

## 🎯 Smart India Hackathon Integration

### Problem Statement
"AI-Based Crop Recommendation for Farmers"

### Solution Approach
1. **Data Collection**: Soil parameters and location data
2. **AI Analysis**: Mock ML model for crop recommendations
3. **Expert Knowledge**: Integrated FAQ and support system
4. **Accessibility**: Multilingual support for rural farmers
5. **Technology**: Modern Flutter app with Firebase backend

### Future Enhancements
- Real ML model integration with TensorFlow Lite
- IoT sensor data integration
- Weather API integration
- Marketplace integration for seeds/fertilizers
- Government scheme notifications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is developed for Smart India Hackathon 2024.

## 📞 Support

For technical support or queries:
- Email: support@sihcropadvisor.gov.in
- Phone: +91-11-2338-9713

---

**Developed with ❤️ for farmers and sustainable agriculture**
