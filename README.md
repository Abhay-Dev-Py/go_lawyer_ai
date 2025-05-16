# GoLawyer AI - Legal Assistant App

A modern Flutter application that provides AI-powered legal assistance through a chat interface. Built with Flutter, Firebase, and GetX state management.

## Features

- 🔐 Email/Password Authentication with Firebase
- 💬 Real-time Chat Interface
- 🤖 AI-powered Legal Advice
- 🔄 Real-time Message Syncing
- 📱 Responsive Design (Mobile, Tablet, Desktop)
- 🎨 Modern UI/UX Design

## Tech Stack

- Flutter
- Firebase Authentication
- Cloud Firestore
- GetX State Management
- Dio for API Calls

## Prerequisites

1. Flutter SDK (latest version)
2. Firebase Project Setup
3. Android Studio / VS Code
4. Firebase CLI

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/go_lawyer_ai.git
cd go_lawyer_ai
```

### 2. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Email/Password Authentication
3. Create a Cloud Firestore database
4. Add your Flutter app to Firebase
5. Download and add the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── modules/
│   ├── auth/               # Authentication
│   ├── chat/               # Chat functionality
│   └── dashboard/          # Future features
├── constants/              # App-wide constants
├── routes/                 # Navigation routes
├── services/              # API and Firebase services
├── utils/                 # Utility functions
├── theme/                 # App theme
└── main.dart             # Entry point
```

## Features in Detail

### Authentication
- Email/Password Sign Up
- Email/Password Sign In
- Persistent Authentication State
- Sign Out Functionality

### Chat Interface
- Real-time Message Updates
- Message History
- Timestamp Display
- Loading States
- Error Handling

### AI Integration
- Legal Question Processing
- AI-powered Responses
- Response Storage
- Error Handling

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Acknowledgments

- Flutter Team
- Firebase
- GetX Team
- AI API Provider
