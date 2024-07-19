import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mother_ai/model/milestone.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class MilestonePage extends StatefulWidget {
  const MilestonePage({super.key});

  @override
  State<MilestonePage> createState() => _MilestonePageState();
}

class _MilestonePageState extends State<MilestonePage> {
  final fixedMilestones = [
    'Social Smile',
    'Rolling Over',
    'Babbles',
    'Sitting Without Support',
    'First Word - Mama or Papa',
    'Crawling',
    'First Step',
    'Laughing'
  ];
  final Box<Milestone> milestoneBox = Hive.box<Milestone>('milestones');
  final Box<Milestone> fixedMilestoneBox = Hive.box<Milestone>('fixed_milestones');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones'),
        backgroundColor: const  Color.fromARGB(0, 36, 140, 114),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddMilestoneDialog(context);
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: milestoneBox.listenable(),
        builder: (context, Box<Milestone> box, _) {
          return ListView.separated(
            itemCount: fixedMilestones.length + box.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Color.fromARGB(255, 154, 178, 46),
            ),
            itemBuilder: (context, index) {
              if (index < fixedMilestones.length) {
                return _buildFixedMilestoneRow(fixedMilestones[index]);
              } else {
                final milestone = box.getAt(index - fixedMilestones.length)!;
                return _buildMilestoneRow(milestone);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildFixedMilestoneRow(String title) {
    DateTime? date = fixedMilestoneBox.get(title)?.date;

    return Container(
      color: const Color.fromARGB(255, 13, 110, 69), // Light purple background color
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(date != null ? DateFormat.yMMMd().format(date) : 'No date'),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final selectedDate = await _selectDate(context, date);
                  if (selectedDate != null) {
                    fixedMilestoneBox.put(title, Milestone(title: title, date: selectedDate));
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneRow(Milestone milestone) {
    return Slidable(
      key: Key(milestone.title),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              milestone.delete();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        color: Colors.purple[50], // Light purple background color
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              milestone.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat.yMMMd().format(milestone.date),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }

  void _showAddMilestoneDialog(BuildContext context) {
    String newTitle = '';
    DateTime newDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Milestone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newTitle = value;
                },
                decoration: const InputDecoration(labelText: 'Milestone'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(DateFormat.yMMMd().format(newDate)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final selectedDate = await _selectDate(context, newDate);
                      if (selectedDate != null) {
                        newDate = selectedDate;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTitle.isNotEmpty) {
                  final milestone = Milestone(title: newTitle, date: newDate);
                  milestoneBox.add(milestone);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}