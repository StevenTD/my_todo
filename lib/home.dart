import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_todo/data/todo.dart';
import 'package:my_todo/todo_bloc/todo_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController txtTitle = TextEditingController();

  TextEditingController txtSubtitle = TextEditingController();

  addTodo(
    Todo todo,
  ) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  removeTodo(
    Todo todo,
  ) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  alterTodo(
    int index,
  ) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My ToDo App'),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.status == TodoStatus.success) {
                return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, int i) {
                      return Card(
                        // color: Theme.of(context)
                        //     .colorScheme
                        //     .primary
                        //     .withOpacity(1),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    removeTodo(state.todos[i]);
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                                title: Text(state.todos[i].title),
                                subtitle: Text(state.todos[i].subtitle),
                                trailing: Checkbox(
                                    value: state.todos[i].isDone,
                                    activeColor:
                                        Theme.of(context).colorScheme.secondary,
                                    onChanged: (value) {
                                      alterTodo(i);
                                    }))),
                      );
                    });
              } else if (state.status == TodoStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return Container();
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog.adaptive(
                  scrollable: true,
                  title: const Text('Add a Task'),
                  content: Column(
                    children: [
                      TextField(
                        controller: txtTitle,
                        decoration: const InputDecoration(
                          labelText: 'Task Title',
                        ),
                      ),
                      TextField(
                        controller: txtSubtitle,
                        decoration: const InputDecoration(
                          labelText: 'Task Subtitle',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          addTodo(
                            Todo(
                              title: txtTitle.text,
                              subtitle: txtSubtitle.text,
                            ),
                          );
                          txtTitle.clear();
                          txtSubtitle.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Save'))
                  ],
                );
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
