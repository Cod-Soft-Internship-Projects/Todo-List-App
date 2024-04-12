import 'package:flutter/material.dart';
import 'package:todo_list_app/services/db_helper.dart';
import 'package:todo_list_app/widgets/toast_message.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

String dropDownPriorityValue = 'High';
String completionStatus = 'Active';
TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Add New Task'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          child: Container(
            height: 650,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Input title',
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 10,
                    decoration: InputDecoration(
                        hintText: 'Write a description (Optional)',
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Priority',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey.shade300,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: dropDownPriorityValue,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropDownPriorityValue = newValue!;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: 'High',
                                      child: Text('High'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Medium',
                                      child: Text('Medium'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Low',
                                      child: Text('Low'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due date',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () async {
                                final DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(3000),
                                );
                                if (dateTime != null) {
                                  setState(() {
                                    selectedDate = dateTime;
                                  });
                                }
                              },
                              child: Chip(padding: EdgeInsets.all(14),backgroundColor: Colors.grey.shade300,
                                label: Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                                avatar: Icon(Icons.date_range),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          insert();
                          titleController.clear();
                          descriptionController.clear();

                          Navigator.pop(context, true);
                          toastMessage('Task added successfully');
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  insert() async {
    await DatabaseHelper.dbInstance.insertRecord({
      DatabaseHelper.title: titleController.text.toString(),
      DatabaseHelper.description: descriptionController.text.toString(),
      DatabaseHelper.priority: dropDownPriorityValue,
      DatabaseHelper.dueDate: selectedDate.toString(),
      DatabaseHelper.completionStatus: completionStatus
    });
  }

  read() async {
    var dbQuery = await DatabaseHelper.dbInstance.readRecord();
    print(dbQuery);
  }
}
