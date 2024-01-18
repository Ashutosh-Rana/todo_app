import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/design_comp.dart/day_selector.dart';
import 'package:todo_app/design_comp.dart/day_with_task.dart';
import 'package:todo_app/design_comp.dart/popup.dart';
import 'package:todo_app/design_comp.dart/task_listview.dart';
import 'package:todo_app/providers/activity_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/add_todo_dialog.dart';
import 'package:todo_app/screens/task_list.dart';
import 'package:todo_app/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TaskProvider taskProvider;

  @override
  void initState() {
    super.initState();
    taskProvider = Provider.of<TaskProvider>(context, listen: false);
    Future.delayed(Duration.zero,() {
      _initializeTasks();
    },);
  }

  Future<void> _initializeTasks() async {
    await taskProvider.loadTasks();
  }
  @override
  Widget build(BuildContext context) {
    // final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Todo App'),
      // ),
      // body: _buildTaskList(activityProvider),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "TO DO LIST",
              style: TextStyle(
                  color: Color(0xffE06E1A),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            // SizedBox(height: 5,),
            Divider(
              color: Colors.black,
              thickness: 1.5,
              indent: 8,
              endIndent: 8,
            ),
            SizedBox(
              height: 20,
            ),
            // TaskListViewWidget()
            DaysWithTasksListWidget(),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:20.0,right: 20),
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomPopup();
              },
            );
          },
          child: Icon(Icons.add,color: AppColors.tertiaryColor,size: 38,),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showAddDialog(context),
      //   tooltip: 'Add Todo',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
