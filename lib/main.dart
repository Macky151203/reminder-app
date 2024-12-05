import 'package:flutter/material.dart';

const Color primaryYellow = Color.fromARGB(255, 241, 178, 19);
const Color secondaryYellow = Color.fromARGB(255, 241, 178, 19);
const Color darkYellow = Color(0xFFB8860B); // Dark golden yellow

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryYellow,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryYellow,
            onPrimary: Colors.black,
          ),
        ),
      ),
      home: ReminderListPage(),
    );
  }
}

class Reminder {
  final String title;
  final String description;
  final DateTime dateTime;
  final Color color;

  Reminder({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.color,
  });
}

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({Key? key}) : super(key: key);

  @override
  State<ReminderListPage> createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  List<Reminder> reminders = [];
  final List<Color> cardColors = [
    Color.fromARGB(255, 136, 250, 239),
    Color.fromARGB(255, 234, 145, 250),
    Color.fromARGB(255, 134, 151, 252),
    Color.fromARGB(255, 141, 248, 145),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newReminder = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddReminderPage()),
              );
              if (newReminder != null) {
                setState(() {
                  reminders.add(newReminder);
                });
              }
            },
          ),
        ],
      ),
      body: reminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders yet. Add some!',
                style: TextStyle(color: Colors.black),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10, // horizontal spacing
                runSpacing: 10, // vertical spacing
                children: List.generate(reminders.length, (index) {
                  final reminder = reminders[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2 -
                        13, // adjust width for 2 columns
                    child: Card(
                      color: reminder.color,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reminder.description,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_getWeekday(reminder.dateTime)} ${_formatTime(reminder.dateTime)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }

  String _getWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({Key? key}) : super(key: key);

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;
  Color _selectedColor = Colors.teal; // Default color

  final List<Color> colorOptions = [
    Color.fromARGB(255, 136, 250, 239),
    Color.fromARGB(255, 234, 145, 250),
    Color.fromARGB(255, 134, 151, 252),
    Color.fromARGB(255, 141, 248, 145),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showConfirmationDialog() async {
    String selectedDay = 'Monday';
    String selectedTime = '5 minutes';

    final List<String> dayOptions = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final List<String> timeOptions = [
      '5 minutes',
      '10 minutes',
      '30 minutes',
      '1 hour'
    ];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: primaryYellow, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              title: const Text(
                'When to Remind?',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<String>(
                    value: selectedDay,
                    isExpanded: true,
                    underline: Container(),
                    items: dayOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDay = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedTime,
                    isExpanded: true,
                    underline: Container(),
                    items: timeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTime = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryYellow),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(0),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  onPressed: () {
                    DateTime now = DateTime.now();
                    DateTime reminderTime = now;

                    // Calculate the reminder time based on selections
                    int selectedWeekday = dayOptions.indexOf(selectedDay) + 1;
                    while (reminderTime.weekday != selectedWeekday) {
                      reminderTime = reminderTime.add(const Duration(days: 1));
                    }

                    if (selectedTime == '5 minutes') {
                      reminderTime =
                          reminderTime.add(const Duration(minutes: 5));
                    } else if (selectedTime == '10 minutes') {
                      reminderTime =
                          reminderTime.add(const Duration(minutes: 10));
                    } else if (selectedTime == '30 minutes') {
                      reminderTime =
                          reminderTime.add(const Duration(minutes: 30));
                    } else if (selectedTime == '1 hour') {
                      reminderTime = reminderTime.add(const Duration(hours: 1));
                    }

                    if (_titleController.text.isNotEmpty) {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(
                        context,
                        Reminder(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dateTime: reminderTime,
                          color: _selectedColor,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title here',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter description here',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              maxLines: null,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showConfirmationDialog,
              child: const Text('Set Reminder'),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: _selectedColor == color
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
