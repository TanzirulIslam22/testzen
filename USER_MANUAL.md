# 📘 TestZen User Manual

* Version: 1.0
* Platform: Android
* Technology Stack: Flutter + Firebase
* Developer: Tanzirul Islam (ID: 2203054, 22 Series, Dept. of CSE, RUET)
* Project Supervisor: Nahin Ul Sadad, Assistant Professor, Dept. of CSE, RUET


---

## 🔰 Introduction

**TestZen** is a mobile exam platform where teachers can create real-time MCQ tests, and students can take exams with a live countdown timer. The app ensures fairness by auto-submitting exams when time runs out and supports result tracking for both parties.

---

## 🧑‍💻 Getting Started

### Step 1: Launch the App

Once installed, open the app on your Android device. You’ll be asked to **select your role**:

* 👨‍🏫 **Admin (Teacher)**
* 👩‍🎓 **Student**

<img src="screenshots/role_selection.jpg" alt="Role Selection" width="150" height="350">

---

## 👨‍🏫 Admin (Teacher) Features

### ✅ 1. Register / Login

* Choose **Admin**
* Enter email and password to log in or register
<div style="display: flex; gap: 10px;">
  <img src="screenshots/login_screen.jpg" alt="Login Screen" width="150" height="350">
    <img src="screenshots/register_as_admin.jpg" alt="Register Screen (admin)" width="150" height="350">
</div>

---

### 🏠 2. Admin Home

After logging in, you'll be directed to the **Admin Dashboard** with options to:

* Create a new exam
* View/edit existing exams
* Add questions
* Review past results

<img src="screenshots/admin_home.jpg" alt="Role Selection" width="150" height="350">


---

### 📝 3. Create Exam

1. Tap on **"Create Exam"**
2. Enter:

    * Exam Title
    * Date & Time
    * Duration (in minutes)
3. Tap **Submit**

<img src="screenshots/create_exam.jpg" alt="Role Selection" width="150" height="350">

---

### ❓ 4. Add Questions

1. After creating the exam, go to **"Add Question"**
2. Enter:

    * Question Text
    * Four options
    * Select the correct answer
3. Tap **Save**

<img src="screenshots/question_creation.jpg" alt="Role Selection" width="150" height="350">

---

### 📋 5. Exam List

* View all created exams
* Edit/delete existing ones if needed


<div style="display: flex; gap: 10px;">
<img src="screenshots/examListAndDeleteExam.jpg" alt="Role Selection" width="150" height="350">
<img src="screenshots/deleteExam.jpg" alt="Role Selection" width="150" height="350">
</div>


---


## 👩‍🎓 Student Features

### ✅ 1. Register / Login

* Choose **Student**
* Enter email and password to log in or register

<div style="display: flex; gap: 10px;">
  <img src="screenshots/login_screen.jpg" alt="Login Screen" width="150" height="350">
  <img src="screenshots/register_as_student.jpg" alt="Register Screen (student)" width="150" height="350">
</div>

---

### 🏠 2. Student Home

* View available exams
* See the list of previous results

<img src="screenshots/student_home.jpg" alt="Register Screen (student)" width="150" height="350">

---

### 📅 3. Available Exams

* See a list of all available exams

 <img src="screenshots/availableOrUpcomingExams.jpg" alt="Register Screen (student)" width="150" height="350">

---


### 🧪 4. Exam Screen

* Answer each MCQ
* Countdown timer is visible
* If you join late, time is adjusted automatically
* Tap **Submit** (or it will auto-submit when time ends)

<img src="screenshots/exam_screen.jpg" alt="Register Screen (student)" width="150" height="350">

---

### ⏳ 5. Waiting Screen for Result

* Once submitted, the result will be displayed after the exam ends.

<img src="screenshots/waiting_screen.jpg" alt="Register Screen (student)" width="150" height="350">

---
### 🧾 6. View Results

* Go to **Results** tab
* View scores 
* Access to the previous exam results

<div style="display: flex; gap: 10px;">
  <img src="screenshots/score_screen.jpg" alt="Register Screen (student)" width="150" height="350">
  <img src="screenshots/previous_result_history.jpg" alt="Register Screen (student)" width="150" height="350">
</div>

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

**Developer:** Tanzirul Islam (ID: 2203054, 22 Series, Dept. of CSE, RUET)
* 📧 Email: [tanzirul.islam56@gmail.com](mailto:tanzirul.islam56@gmail.com)
* 🔗 GitHub: [TanzirulIslam22](https://github.com/TanzirulIslam22)

