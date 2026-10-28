import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'University of Technology Sarawak - Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LabHomeScreen(),
    );
  }
}

// ==========================================
// 1. Decomposed Widgets
// ==========================================

class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/my_photo.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'DERRICK FREDERICK CHUNG SHYAN HUNG',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Student ID: BCS24090008',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const Divider(height: 32, thickness: 1),
              const Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'I want to be rich',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.star, color: Colors.red[500]),
              const SizedBox(width: 4),
              Text('$starCount'),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;
  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ==========================================
// 2. Main Screen with Adaptive Layout & Pickers
// ==========================================

class LabHomeScreen extends StatefulWidget {
  const LabHomeScreen({super.key});

  @override
  State<LabHomeScreen> createState() => _LabHomeScreenState();
}

class _LabHomeScreenState extends State<LabHomeScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Slytherin';
  final List<String> _roles = ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff'];

  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: _roles.indexOf(_selectedRole),
          ),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = _roles[index]);
          },
          children: _roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTS Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      children: [
        const StudentDetailsSection(),
        const TitleSection(
          name: 'University of Technology Sarawak (UTS)',
          location: 'Sibu, Sarawak',
          starCount: 41,
        ),
        const ImageSection(imagePath: 'assets/UTS.png'),
        _buildPickersSection(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Row(
      children: [
        const Expanded(child: StudentDetailsSection()),
        Expanded(
          child: ListView(
            children: [
              const TitleSection(
                name: 'University of Technology Sarawak (UTS)',
                location: 'Sibu, Sarawak',
                starCount: 41,
              ),
              const ImageSection(imagePath: 'assets/UTS.png'),
              _buildPickersSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickersSection() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interactive Pickers (Lab 2.2)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text('Selected Date: ${_selectedDate.toIso8601String().split('T')[0]}'),
          Text('Selected House: $_selectedRole'),
          const Divider(height: 20),
          ElevatedButton.icon(
            onPressed: () => _selectMaterialDate(context),
            icon: const Icon(Icons.calendar_today),
            label: const Text('Material DatePicker'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showCupertinoDatePicker(context),
            icon: const Icon(Icons.ios_share),
            label: const Text('Cupertino Date Picker (Modal Sheet)'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Material Dropdown: '),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedRole,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedRole = newValue);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showCupertinoRolePicker(context),
            icon: const Icon(Icons.unfold_more),
            label: const Text('Cupertino House Wheel Picker'),
          ),
        ],
      ),
    );
  }
}