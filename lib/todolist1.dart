import 'package:flutter/material.dart';
import 'todo1.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;

  const ToDoItem({Key? key, required this.todo, required this.onToDoChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff7E1636),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.6),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Color.fromARGB(255, 95, 51, 51),
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Color.fromARGB(255, 232, 227, 228),
        ),
        title: Text(todo.todoText!,
            style: TextStyle(fontSize: 18, color: Colors.white)),
        /* trailing: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 134, 86, 100),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.6),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ElevatedButton(
            color: Colors.white,
            iconSize: 19,
           // icon: Icon(Icons.delete),
            onPressed: () {
              print("delete icon");
            },
          ),
        ),*/
      ),
    );
  }
}
