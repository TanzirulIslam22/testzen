# 📘 TestZen User Manual

**Version:** 1.0
**Platform:** Android
**Technology Stack:** Flutter + Firebase
**Developer:** Tanzirul Islam

---

## 🔰 Introduction

**TestZen** is a mobile exam platform where teachers can create real-time MCQ tests, and students can take exams with a live countdown timer. The app ensures fairness by auto-submitting exams when time runs out and supports result tracking for both parties.

---

## 🧑‍💻 Getting Started

### Step 1: Launch the App

Once installed, open the app on your Android device. You’ll be asked to **select your role**:

* 👨‍🏫 **Admin (Teacher)**
* 👩‍🎓 **Student**

📷 *Insert screenshot here of role selection screen*

---

## 👨‍🏫 Admin (Teacher) Features

### ✅ 1. Register / Login

* Choose **Admin**
* Enter email and password to log in or register

[//]: # (![Role Selection]&#40;screenshots/role_selection.jpg&#41;)

[//]: # (![Login Screen]&#40;screenshots/login_screen.jpg&#41;)

[//]: # (![Register Screen&#40;admin&#41;]&#40;screenshots/Resigster_as_admin.jpg&#41;)

[//]: # (![Register Screen&#40;student&#41;]&#40;screenshots/Resigster_as_student.jpg&#41;)
<img src="screenshots/role_selection.jpg" alt="Role Selection" width="400">
<img src="screenshots/login_screen.jpg" alt="Login Screen" width="400">
<img src="screenshots/register_as_admin.jpg" alt="Register Screen (admin)" width="400">
<img src="screenshots/register_as_student.jpg" alt="Register Screen (student)" width="400">
---

### 🏠 2. Admin Home

After logging in, you'll be directed to the **Admin Dashboard** with options to:

* Create a new exam
* View/edit existing exams
* Add questions
* Review past results

📷 *Insert screenshot of admin\_home.dart UI*

---

### 📝 3. Create Exam

1. Tap on **"Create Exam"**
2. Enter:

    * Exam Title
    * Date & Time
    * Duration (in minutes)
3. Tap **Submit**

📷 *Insert screenshot from create\_exam\_screen.dart*

---

### ❓ 4. Add Questions

1. After creating the exam, go to **"Add Question"**
2. Enter:

    * Question Text
    * Four options
    * Select the correct answer
3. Tap **Save**

📷 *Insert screenshot from add\_question\_screen.dart*

---

### 📋 5. Exam List

* View all created exams
* Edit/delete existing ones if needed

📷 *Insert screenshot from exam\_list\_screen.dart*

---

### 📈 6. View Results

* Select a past exam to see the list of students who attempted it and their performance.

📷 *Insert screenshot from result view screen (admin)*

---

## 👩‍🎓 Student Features

### ✅ 1. Register / Login

* Choose **Student**
* Enter email and password to log in or register

📷 *Insert screenshot from login\_screen.dart / register\_screen.dart*

---

### 🏠 2. Student Home

View upcoming or ongoing exams.

📷 *Insert screenshot from student\_home.dart*

---

### 📅 3. Available Exams

* See a list of all available exams
* Tap on **"Register"** for upcoming ones

📷 *Insert screenshot from available\_exam\_screen.dart*

---

### ⏳ 4. Waiting Room

* Once registered, you’ll be placed in a waiting screen until the exam begins

📷 *Insert screenshot from waiting\_screen.dart*

---

### 🧪 5. Exam Screen

* Answer each MCQ
* Countdown timer is visible
* If you join late, time is adjusted automatically
* Tap **Submit** (or it will auto-submit when time ends)

📷 *Insert screenshot from exam\_screen.dart*

---

### 🧾 6. View Results

* Go to **Results** tab
* View score, correct answers, and personal progress

📷 *Insert screenshot from results\_screen.dart*
📷 *Insert screenshot from single\_exam\_result\_screen.dart*

---

## 🧠 Summary of Key Features

| Feature               | Admin       | Student         |
| --------------------- | ----------- | --------------- |
| Register/Login        | ✅           | ✅               |
| Create Exams          | ✅           | ❌               |
| Add Questions         | ✅           | ❌               |
| Join Exams            | ❌           | ✅               |
| Real-Time Timer       | ✅ (view)    | ✅ (use)         |
| Late Join Adjustments | ✅           | ✅               |
| Auto Submission       | ✅ (enabled) | ✅ (experienced) |
| View Results          | ✅           | ✅               |

---

## 📫 Support

**Developer:** Tanzirul Islam
📧 Email: [tanzirul.islam56@gmail.com](mailto:tanzirul.islam56@gmail.com)
🔗 GitHub: [TanzirulIslam22](https://github.com/TanzirulIslam22)

---

### 🔧 Notes:

* This is the first version; future updates will include iOS support and UI improvements.
* For any issues or bugs, please contact the developer via email or GitHub.

