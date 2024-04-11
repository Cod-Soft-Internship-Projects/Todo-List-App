import 'package:flutter/material.dart';
import 'package:todo_list_app/add_task_screen.dart';
import 'package:todo_list_app/db_helper.dart';
import 'package:todo_list_app/edit_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool taskCompletionStatus = false;

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
                  '13 tasks are pending',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
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
                              // color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(child: Text('No tasks found',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w400),)));
                        } else {
                          return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: ListTileTheme(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      tileColor:
                                          Colors.blueAccent.withOpacity(.5),
                                      leading: InkWell(
                                        onTap: () {
                                          setState(() {
                                            taskCompletionStatus =
                                                !taskCompletionStatus;
                                          });
                                        },
                                        child: Icon(
                                          taskCompletionStatus == true
                                              ? Icons.check_box_outlined
                                              : Icons.check_box_outline_blank,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        data[index]['Title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle:
                                          Text(data[index]['CompletionStatus']),
                                      trailing: InkWell(
                                        onTap: () async{
                                          await DatabaseHelper.dbInstance.deleteRecord(index);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditTaskScreen()));
                                      },
                                    ),
                                  ),
                                );
                              });
                        }
                      }
                      return Text('No tasks found');
                    }),
              ),
            ),
          ),
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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTaskScreen()));
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  read() async {
    var dbQuery = await DatabaseHelper.dbInstance.readRecord();
    print(dbQuery);
  }
}
