class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      /* ToDo(id: '01', todoText: 'Morning walk', isDone: true),
      ToDo(id: '02', todoText: 'walk', isDone: true),
      ToDo(id: '03', todoText: 'eggs', isDone: true),
      ToDo(id: '01', todoText: 'Morning '),*/
    ];
  }
}
