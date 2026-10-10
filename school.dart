// Student: Farah Alhasan
// Student Number: 21120205709

// Week 3 Homework - OOP in Dart (Secretary, Teacher, Student)
// Covers: functions, classes, inheritance, polymorphism, encapsulation
// Run with: dart run school.dart

// ---------------------------------------------------------------------------
// Base class (inheritance + encapsulation)
// ---------------------------------------------------------------------------

abstract class Person {
  // Private fields: only accessible through getters/setters (encapsulation).
  String _name;
  int _age;

  Person(this._name, this._age);

  String get name => _name;
  int get age => _age;

  set age(int value) {
    if (value > 0) {
      _age = value;
    } else {
      print('Age must be positive.');
    }
  }

  // Every subclass studies in its own way (polymorphism).
  void study();

  void introduce() {
    print('Hi, I am $_name, $_age years old.');
  }
}

// ---------------------------------------------------------------------------
// Teacher
// ---------------------------------------------------------------------------

class Teacher extends Person {
  final String _subject;

  Teacher(String name, int age, this._subject) : super(name, age);

  String get subject => _subject;

  @override
  void study() {
    print('Teacher $name is studying $_subject to prepare the lecture.');
  }

  void giveExam(List<Student> students) {
    print('\nTeacher $name is giving a $_subject exam.');
    for (var student in students) {
      student.takeExam(_subject);
    }
  }

  @override
  void introduce() {
    super.introduce();
    print('I teach $_subject.');
  }
}

// ---------------------------------------------------------------------------
// Student
// ---------------------------------------------------------------------------

class Student extends Person {
  final String _studentNumber;
  final Map<String, int> _grades = {};
  int _studyHours = 0;

  Student(String name, int age, this._studentNumber) : super(name, age);

  String get studentNumber => _studentNumber;

  // Return a copy so grades cannot be changed from outside.
  Map<String, int> get grades => Map.unmodifiable(_grades);

  @override
  void study() {
    _studyHours += 2;
    print('Student $name is studying (total study hours: $_studyHours).');
  }

  void takeExam(String subject) {
    int grade = calculateGrade(_studyHours);
    _grades[subject] = grade;
    print('Student $name took the $subject exam and got $grade.');
  }

  @override
  void introduce() {
    super.introduce();
    print('My student number is $_studentNumber.');
  }
}

// ---------------------------------------------------------------------------
// Secretary (adds teachers and students)
// ---------------------------------------------------------------------------

class Secretary extends Person {
  final List<Teacher> _teachers = [];
  final List<Student> _students = [];

  Secretary(String name, int age) : super(name, age);

  List<Teacher> get teachers => List.unmodifiable(_teachers);
  List<Student> get students => List.unmodifiable(_students);

  void addTeacher(Teacher teacher) {
    _teachers.add(teacher);
    print('Secretary $name added teacher ${teacher.name} (${teacher.subject}).');
  }

  void addStudent(Student student) {
    _students.add(student);
    print('Secretary $name added student ${student.name} (${student.studentNumber}).');
  }

  @override
  void study() {
    print('Secretary $name is studying the school registration rules.');
  }
}

// ---------------------------------------------------------------------------
// Helper function
// ---------------------------------------------------------------------------

/// More study hours give a better grade (max 100).
int calculateGrade(int studyHours) {
  int grade = 50 + studyHours * 10;
  return grade > 100 ? 100 : grade;
}

void main() {
  Secretary secretary = Secretary('Ayse', 35);

  print('=== Registration ===');
  secretary.addTeacher(Teacher('Mehmet', 45, 'Mobile Applications'));
  secretary.addTeacher(Teacher('Elif', 38, 'Mathematics'));
  secretary.addStudent(Student('Ali', 20, 'S001'));
  secretary.addStudent(Student('Zeynep', 21, 'S002'));

  // Encapsulation: setter validation.
  secretary.students[0].age = -5;

  // Polymorphism: the same call behaves differently for each type.
  print('\n=== Everyone studies ===');
  List<Person> people = [secretary, ...secretary.teachers, ...secretary.students];
  for (var person in people) {
    person.study();
  }

  // Zeynep studies a bit more.
  secretary.students[1].study();

  print('\n=== Exams ===');
  for (var teacher in secretary.teachers) {
    teacher.giveExam(secretary.students);
  }

  print('\n=== Introductions ===');
  for (var person in people) {
    person.introduce();
  }

  print('\n=== Report ===');
  for (var student in secretary.students) {
    print('${student.name}: ${student.grades}');
  }
}
