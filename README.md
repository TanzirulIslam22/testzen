# 🧪 TestZen — Real-Time MCQ Exam App for Teachers and Students

TestZen is a mobile application built with **Flutter** and powered by **Firebase**, designed to simplify and automate the online examination process. It provides real-time MCQ-based exams with features like countdown timers, late join handling, auto-submission, and detailed exam history tracking — all from a single platform.

---

## ✨ Key Features

### 👨‍🏫 For Teachers (Admins)

* Register and log in securely
* Create MCQ-based exams with 4 options per question
* Set exam title, date, time, and duration
* Add, edit, or delete questions
* View student participation and performance
* Review past exam data

### 👩‍🎓 For Students

* Sign up and log in securely
* Register for upcoming exams
* Join live exams with real-time timer (adjusts for late joiners)
* Auto-submit answers when time expires
* View results and correct answers after submission
* Track performance history

---

## 🔧 Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend:** Firebase (Cloud Firestore)
* **Authentication:** Firebase Authentication
* **Architecture:** MVVM (Model-View-ViewModel)
* **State Management:** `Provider`, `setState`
* **Platform:** Android only (iOS support planned)

---

## 🚀 Getting Started

### ✅ Prerequisites

* Flutter SDK (v3.0 or later)
* Dart SDK
* Firebase Project (configured for Android)
* IDE: Android Studio / VS Code

### 🔨 Installation Steps

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/testzen.git
cd testzen
```

2. **Install Flutter packages**

```bash
flutter pub get
```

3. **Configure Firebase**

* Go to your Firebase Console
* Download `google-services.json` and place it in `android/app/`
* Enable **Email/Password** authentication
* Create `Cloud Firestore` database in test mode (for development)

4. **Run the app**

```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── models/                         # Data models
│   ├── question_model.dart         # Question model
│   └── result_model.dart           # Result model
│
├── screens/
│   ├── admin/                      # Admin-specific screens
│   │   ├── add_question_screen.dart
│   │   ├── admin_home.dart
│   │   ├── create_exam_screen.dart
│   │   └── exam_list_screen.dart
│   │
│   ├── auth/                       # Authentication screens
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── role_selection.dart
│   │
│   └── student/                    # Student-specific screens
│       ├── available_exam_screen.dart
│       ├── exam_screen.dart
│       ├── results_screen.dart
│       ├── single_exam_result_screen.dart
│       ├── student_home.dart
│       └── waiting_screen.dart
│
├── services/                       # App services
│   ├── auth_service.dart
│   ├── database_service.dart
│   └── exam_service.dart
│
├── auth_wrapper.dart               # Role-based redirection logic
├── firebase_options.dart           # Firebase config (auto-generated)
└── main.dart                       # App entry point

```

---

## 🧪 Testing

To run tests:

```bash
flutter test
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  cloud_firestore: ^5.6.6
  intl: ^0.20.2
  provider: ^6.1.1
  firebase_auth: ^5.5.2
  firebase_core: ^3.13.0
  flutter_local_notifications: ^19.1.0
  get: ^4.7.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## 📫 Contact

**Developer:** Tanzirul Islam(2203054_RUET_CSE_22Series)
* 📧 Email: [tanzirul.islam56@gmail.com](mailto:tanzirul.islam56@gmail.com)
* 🔗 GitHub: [@TanzirulIslam22](https://github.com/TanzirulIslam22)



