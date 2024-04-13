import 'package:flutter/material.dart';
import 'package:todo_list_app/services/db_helper.dart';

class EditTaskScreen extends StatefulWidget {
  int id;
  String title;
  String description;
  String priority;
  String dueDate;
  String completionStatus;

  EditTaskScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.dueDate,
      required this.completionStatus});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.parse(widget.dueDate);
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if(_formKey.currentState!.validate()){
          update();
        }
        
        
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Update Task'),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                                          textCapitalization: TextCapitalization.sentences,
      
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Update title',
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Description',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                                          textCapitalization: TextCapitalization.sentences,
      
                      controller: descriptionController,
                      maxLines: 10,
                      decoration: InputDecoration(
                          hintText: 'Update description',
                           filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),),
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
                                  
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey.shade300,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: widget.priority,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        widget.priority = newValue!;
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
                                child: Chip(
                                  padding: EdgeInsets.all(13),backgroundColor: Colors.grey.shade300,
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
                            update();
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(
                          'Update',
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
      ),
    );
  }

  update() async {
    await DatabaseHelper.dbInstance.updateRecord(
      {
        DatabaseHelper.title: titleController.text.toString(),
        DatabaseHelper.description: descriptionController.text.toString(),
        DatabaseHelper.priority: widget.priority,
        DatabaseHelper.dueDate: selectedDate.toString(),
        DatabaseHelper.completionStatus: widget.completionStatus
      },
      widget.id,
    );
  }

  read() async {
    var dbQuery = await DatabaseHelper.dbInstance.readRecord();
    print(dbQuery);
  }
}
