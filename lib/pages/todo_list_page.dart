import 'package:flutter/material.dart';
import 'package:todo_list_udemy/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<String> todos = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicionar tarefa',
                          hintText: 'Fazer compras',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff58d8b5),
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () {
                          String text = todoController.text;
                          setState(() {
                            todos.add(text);
                          });
                          todoController.clear();
                        },
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (String todo in todos)
                        TodoListItem(
                          title: todo,
                        ),
                      // ListTile(
                      //   // selected: true,
                      //   // dense: true,
                      //   title: const Text('Tarefa 2'),
                      //   subtitle: const Text('26/03/2022'),
                      //   leading: const Icon(
                      //     Icons.add_alarm,
                      //     size: 30,
                      //     color: Colors.blue,
                      //     semanticLabel: 'Save',
                      //   ),
                      //   onTap: () {
                      //     print('Alarme');
                      //   },
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff58d8b5),
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        setState(() {
                          todos.clear();
                        });
                      },
                      child: const Text('Limpar tudo'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
