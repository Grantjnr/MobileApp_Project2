import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CourseApp());
}

class CourseApp extends StatelessWidget {
  const CourseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Course Dashboard",
      debugShowCheckedModeBanner: false,
      home: const DashboardHome(),
    );
  }
}

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedIndex = 0;
  String _selectedCategory = "Science";
  double _scale = 1.0;

  // Sample courses
final List<Map<String, dynamic>> courses = [
  {
    "name": "Mobile App Development",
    "instructor": "Mr. Emmanuel",
    "icon": Icons.phone_android
  },
  {
    "name": "Python Programming",
    "instructor": "Mr. Ayitey",
    "icon": Icons.code   // using a generic code icon
  },
  {
    "name": "Information Technology Management",
    "instructor": "Dr. Addo",
    "icon": Icons.computer   // computer icon
  },
  {
    "name": "Information Security",
    "instructor": "Papa Jay",
    "icon": Icons.security   // shield/security icon
  },
  {
    "name": "Network Server",
    "instructor": "Mr. Andy",
    "icon": Icons.dns   // server/network icon
  },
];


  final List<String> categories = ["Science", "Arts", "Technology"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Dashboard"),
        actions: [
          TextButton.icon(
            onPressed: _confirmExit,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text("Logout", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    String tabName;
    if (_selectedIndex == 0) {
      tabName = "Home";
    } else if (_selectedIndex == 1) {
      tabName = "Courses";
    } else {
      tabName = "Profile";
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// b) Active tab name prominently
          Center(
            child: Text(
              "Current Tab: $tabName",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          /// a) Course List View (only show in Courses tab)
          if (_selectedIndex == 1)
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final c = courses[index];
                  return ListTile(
                    leading: Icon(c["icon"]),
                    title: Text(c["name"]),
                    subtitle: Text("Instructor: ${c["instructor"]}"),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  _selectedIndex == 0
                      ? "Welcome to the Home tab."
                      : "Profile settings here.",
                ),
              ),
            ),

          const SizedBox(height: 16),

          /// e) Course Selection Dropdown
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedCategory = val!;
              });
            },
            decoration: const InputDecoration(labelText: "Select Category"),
          ),
          const SizedBox(height: 8),
          Text("Selected: $_selectedCategory"),

          const SizedBox(height: 20),

          /// d) Animated Enroll Button
          Center(
            child: GestureDetector(
              onTapDown: (_) => setState(() => _scale = 1.2),
              onTapUp: (_) {
                setState(() => _scale = 1.0);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enrolled successfully!")),
                );
              },
              onTapCancel: () => setState(() => _scale = 1.0),
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 150),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.school),
                  label: const Text("Enroll in a Course"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// c) Exit Confirmation Dialog
  void _confirmExit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Exit"),
        content: const Text("Are you sure you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // No
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // Yes, exit app
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
