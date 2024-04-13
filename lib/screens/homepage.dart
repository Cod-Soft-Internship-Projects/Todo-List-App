import 'package:flutter/material.dart';
import 'package:todo_list_app/services/db_helper.dart';
import 'package:todo_list_app/screens/add_task_screen.dart';
import 'package:todo_list_app/screens/edit_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalActiveTasks = 0;
  @override
  void initState() {
    countActiveTasks();
    super.initState();
  }

  countActiveTasks() async {
    final data = await DatabaseHelper.dbInstance.readRecord();
    totalActiveTasks =
        data.where((element) => element['CompletionStatus'] == 'Active').length;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Muhammad Ahsan',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  totalActiveTasks == 1
                      ? '$totalActiveTasks task is pending'
                      : '$totalActiveTasks tasks are pending',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: FutureBuilder(
                    future: DatabaseHelper.dbInstance.readRecord(),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        if (data.isEmpty) {
                          return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                'No tasks found\nCreate your first task by\nclicking the button below',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              )));
                        } else {
                          return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                
                                return InkWell(
                                  onTap: () async {
                                    var refresh = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditTaskScreen(
                                                    id: data[index]['Id'],
                                                    title: data[index]['Title'],
                                                    description: data[index]
                                                        ['Description'],
                                                    priority: data[index]
                                                        ['Priority'],
                                                    dueDate: data[index]
                                                        ['DueDate'],
                                                    completionStatus: data[
                                                            index]
                                                        ['CompletionStatus'])));
                                    if (refresh == true || refresh == null) {
                                      setState(() {
                                        refresh = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 10),
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        right: 20,
                                        bottom: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(DateTime.parse(
                                                      data[index]['DueDate'])
                                                  .day
                                                  .toString() +'/'+
                                              DateTime.parse(
                                                      data[index]['DueDate'])
                                                  .month
                                                  .toString() +'/'+
                                              DateTime.parse(
                                                      data[index]['DueDate'])
                                                  .year
                                                  .toString())
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  await DatabaseHelper
                                                      .dbInstance
                                                      .updateRecord(
                                                    {
                                                      if (data[index][
                                                              'CompletionStatus'] ==
                                                          'Completed')
                                                        DatabaseHelper
                                                                .completionStatus:
                                                            'Active'
                                                      else if (data[index][
                                                              'CompletionStatus'] ==
                                                          'Active')
                                                        DatabaseHelper
                                                                .completionStatus:
                                                            'Completed'
                                                    },
                                                    data[index]['Id'],
                                                  );
                                                  countActiveTasks();
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  data[index]['CompletionStatus'] ==
                                                          'Completed'
                                                      ? Icons.check_box
                                                      : Icons
                                                          .check_box_outline_blank,
                                                  size: 30,
                                                )),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ConstrainedBox(
                                                  
                                                  constraints: BoxConstraints(maxWidth: 150),
                                                  child: Text(
                                                    data[index]['Title'],
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: 150),
                                                  child: Text(
                                                    data[index]
                                                              ['Description'] ==
                                                          ''
                                                      ? 'No description written'
                                                      : data[index]
                                                          ['Description'],
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,),
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () async {
                                                await DatabaseHelper.dbInstance
                                                    .deleteRecord(
                                                        data[index]['Id']);
                                                countActiveTasks();
            
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Chip(
                                              backgroundColor: Colors.blueAccent
                                                  .withOpacity(.2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0.0),
                                              ),
                                              label: Text(data[index]
                                                  ['CompletionStatus'])),
                                          Chip(
                                              backgroundColor: Colors.blueAccent
                                                  .withOpacity(.2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0.0),
                                              ),
                                              label: Text(
                                                  '${data[index]['Priority']} priority task'))
                                        ],
                                      )
                                    ]),
                                  ),
                                );
                              });
                        }
                      }
                      return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            'Loading...',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )));
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: Container(
              decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent)),
            ),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 200,
        child: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            child: Text('Add new task'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () async {
              var refresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTaskScreen()));
              if (refresh == true || refresh == null) {
                setState(() {
                  refresh = false;
                  countActiveTasks();
                });
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
