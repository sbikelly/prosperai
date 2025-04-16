ProsperAI

An AI-Powered Educational Assistant for Federal College of Education, Pankshin

ProsperAI is a cross-platform mobile application designed to enhance academic support at the Federal College of Education, Pankshin, Nigeria. Built with Flutter, it leverages the Gemini API for intelligent query processing and Hive for offline data storage, providing students and lecturers with real-time academic assistance, even in low-connectivity environments. The app features secure authentication, AI-driven chat, chat history management, user profile customization, registration, administrative user management, and settings, addressing the needs of a resource-constrained educational setting.
Features

    User Authentication: Secure login and registration for students and lecturers, with role-based access.
    AI-Powered Chat: Real-time academic query processing using the Gemini API, supporting subjects like Mathematics and Biology.
    Offline Chat History: Stores and retrieves chat sessions locally via Hive, ensuring access without internet connectivity.
    Profile Management: Allows users to view and update personal details (e.g., name, email, role).
    User Registration: Enables new users to create accounts with validated inputs.
    User Management: Administrative controls for lecturers to manage user accounts (view, edit, delete).
    Settings Customization: Options to toggle themes (light/dark) and clear chat data for privacy.
    Responsive Design: Cross-platform compatibility for Android and iOS, built with Flutter’s widget-based UI.

Prerequisites

To run ProsperAI locally, ensure you have the following:

    Flutter SDK: Version 3.10.0 or higher (Install Flutter)
    Dart: Version 3.0.0 or higher (included with Flutter)
    Gemini API Key: Obtain from Google Cloud Console (Gemini API Docs)
    IDE: Visual Studio Code or Android Studio with Flutter plugins
    Emulator or Device: Android (API 21+) or iOS (12.0+) for testing
    Git: For cloning the repository

Installation

    Clone the Repository:
    bash

git clone https://github.com/sbikelly/prosperai.git
cd prosperai
Install Dependencies: Run the following to fetch Flutter packages:
bash
flutter pub get
Configure Environment:

    Create a .env file in the project root:
    plaintext

    GEMINI_API_KEY=your_gemini_api_key_here
    Ensure the key is valid and corresponds to an active Gemini API project.

Initialize Hive: Hive requires initialization for local storage. This is handled in main.dart, but ensure write permissions on the device/emulator.
Run the App: Start the app on an emulator or connected device:
bash

    flutter run

Project Structure
text
/prosperai
├── /lib
│   ├── /models         # Data models (User, ChatMessage, ChatSession)
│   ├── /screens        # UI screens (LoginScreen, ChatScreen, etc.)
│   ├── /services       # Backend services (ApiService, DatabaseService)
│   ├── /viewmodels     # MVVM logic (AuthViewModel, ChatViewModel)
│   ├── /widgets        # Reusable UI components (MessageBubble, CustomButton)
│   ├── main.dart       # App entry point
├── /assets             # Icons and static resources
├── /test               # Unit and integration tests
├── .env                # Environment variables (API keys)
├── pubspec.yaml        # Dependencies and configurations
Usage

    Login or Register:
        Launch the app and log in with existing credentials or register a new account (username, email, password, role).
        Lecturers can access administrative features with elevated permissions.
    Interact with AI Chat:
        Navigate to the Chat Screen, select or create a session (e.g., "Biology Chat").
        Enter academic queries (e.g., "What is osmosis?") and receive real-time responses.
        Offline mode retrieves cached chats if no internet is available.
    Manage Profile:
        Update personal details (name, email) in the Profile Screen.
    Admin Functions:
        Lecturers can access User Management to view, edit, or delete user accounts.
    Customize Settings:
        Toggle between light and dark themes or clear chat history for privacy.

Testing

ProsperAI includes unit and integration tests in the /test directory. To run tests:
bash
flutter test

Key test cases cover:

    Authentication (valid/invalid credentials)
    Chat functionality (query processing, offline retrieval)
    Data persistence (Hive storage/retrieval)

Deployment

    Build for Android:    
    Run: flutter build apk --release

Output: build/app/outputs/flutter-apk/app-release.apk


    Build for iOS:
    Run: flutter build ios --release (Requires Xcode and an Apple Developer account for App Store submission.)
    Distribution:
        Android: Sideload APK or publish to Google Play Store.
        iOS: Submit to App Store after configuring in Xcode.

Dependencies

    flutter: ^3.10.0
    hive: ^2.2.3
    hive_flutter: ^1.1.0
    http: ^0.13.5
    flutter_dotenv: ^5.0.2
    get_it: ^7.2.0 (for dependency injection)
    See pubspec.yaml for the full list.

Contributing

Contributions are welcome! To contribute:

    Fork the repository.
    Create a feature branch (git checkout -b feature-name).
    Commit changes (git commit -m "Add feature").
    Push to the branch (git push origin feature-name).
    Open a pull request.

Please adhere to the Contributor Covenant Code of Conduct.
Troubleshooting

    Gemini API Errors:
        Verify the API key in .env is active and quota limits are not exceeded.
        Check network connectivity for online mode.
    Hive Storage Issues:
        Ensure device storage permissions are granted.
        Reinitialize Hive with flutter clean and flutter pub get if data fails to persist.
    UI Rendering:
        Confirm Flutter version compatibility.
        Run flutter doctor to diagnose setup issues.

License

This project is licensed under the MIT License. See the  file for details.
Acknowledgments

    Federal College of Education, Pankshin, for providing the context and support.
    Google for the Gemini API and Flutter framework.
    Hive Team for lightweight local storage solutions.

Contact

For inquiries or feedback, reach out to adokweb17@gmail.com, adokweishaq@fcepkn.edu.ng, sbikelly@gmail.com
