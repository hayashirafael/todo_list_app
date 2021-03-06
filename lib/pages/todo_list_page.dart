import 'package:flutter/material.dart';
import 'package:todo_list_udemy/models/todo.dart';
import 'package:todo_list_udemy/repositories/todo_repository.dart';
import 'package:todo_list_udemy/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicionar tarefa',
                          hintText: 'Ex. Fazer compras',
                          errorText: errorText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () {
                          String text = todoController.text;
                          if (text.isEmpty) {
                            setState(() {
                              errorText = 'O t??tulo n??o pode ser vazio!';
                            });
                            return;
                          }
                          setState(() {
                            Todo newTodo = Todo(
                              title: text,
                              dateTime: DateTime.now(),
                            );
                            todos.add(newTodo);
                            setState(() {
                              errorText = null;
                            });
                          });
                          todoController.clear();
                          todoRepository.saveTodoList(todos);
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
                      for (Todo todo in todos)
                        TodoListItem(todo: todo, onDelete: onDelete),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Voc?? possui ${todos.length} tarefas pendentes'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: showDeleteConfirmationDialog,
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

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
      todoRepository.saveTodoList(todos);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa ${todo.title} removido com sucesso!'),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
              todoRepository.saveTodoList(todos);
            });
          },
          textColor: Colors.black,
        ),
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar a????o.'), //T??tulo
        content: const Text(
            'Voc?? tem certeza que deseja apagar todas as tarefas?'), //Text da a????o
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //Sair do modo janela.
              FocusManager.instance.primaryFocus?.unfocus(); // Esconder teclado
            },
            child: const Text('Cancelar'),
            style: TextButton.styleFrom(primary: Colors.blue),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //Sair do modo janela.
              setState(() {
                todos.clear();
              });
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: const Text('Apagar'),
            style: TextButton.styleFrom(primary: Colors.red),
          ),
        ],
      ),
    );
  }
}
