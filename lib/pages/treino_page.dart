import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TreinoPage extends StatefulWidget {
  const TreinoPage({super.key});

  @override
  State<TreinoPage> createState() => _TreinoPageState();
}

class _TreinoPageState extends State<TreinoPage> {
  List<Map<String, dynamic>> exercicios = [
    {'nome': 'Supino Reto', 'feito': false},
    {'nome': 'Crucifixo', 'feito': false},
    {'nome': 'Flexão', 'feito': false},
    {'nome': 'Tríceps Corda', 'feito': false},
  ];
void abrirDialogAdicionarExercicio() {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Novo exercício'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Digite o nome do exercício',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  exercicios.add({
                    'nome': controller.text.trim(),
                    'feito': false,
                  });
                });

                salvarExercicios();
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      );
    },
  );
}

void editarExercicio(int index) {
  final TextEditingController controller = TextEditingController(
    text: exercicios[index]['nome'],
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar exercício'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  exercicios[index]['nome'] = controller.text.trim();
                });

                salvarExercicios();
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}

  @override
  void initState() {
    super.initState();
    carregarExercicios();
  }

  Future<void> salvarExercicios() async {
    final prefs = await SharedPreferences.getInstance();
    String dados = jsonEncode(exercicios);
    await prefs.setString('exercicios', dados);
  }

  Future<void> carregarExercicios() async {
    final prefs = await SharedPreferences.getInstance();
    String? dados = prefs.getString('exercicios');

    if (dados != null) {
      setState(() {
        exercicios = List<Map<String, dynamic>>.from(jsonDecode(dados));
      });
    }
  }

  int get totalFeitos {
    return exercicios.where((e) => e['feito'] == true).length;
  }

  double get progresso {
    return totalFeitos / exercicios.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
  title: const Text('Treino de Hoje'),
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  actions: [
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: abrirDialogAdicionarExercicio,
    ),
  ],
),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progresso',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        '$totalFeitos/${exercicios.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                TweenAnimationBuilder<double>(
  tween: Tween<double>(
    begin: 0,
    end: progresso,
  ),
  duration: const Duration(milliseconds: 500),
  builder: (context, value, child) {
    return LinearProgressIndicator(
      value: value,
      minHeight: 10,
      backgroundColor: Colors.white24,
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    );
  },
),  
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercicios.length,
                itemBuilder: (context, index) {
                  final exercicio = exercicios[index];

                return Dismissible(
  key: Key(exercicio['nome']),
  direction: DismissDirection.endToStart,

  onDismissed: (direction) {
    setState(() {
      exercicios.removeAt(index);
    });

    salvarExercicios();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercicio['nome']} removido'),
      ),
    );
  },

  background: Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Icon(
      Icons.delete,
      color: Colors.white,
      size: 30,
    ),
  ),

  child: Container( 
  margin: const EdgeInsets.only(bottom: 14),
  decoration: BoxDecoration(
    color: exercicio['feito'] ? Colors.black : Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: Colors.black12),
  ),
  child: GestureDetector(
  onLongPress: () {
    editarExercicio(index);
  },
  child: CheckboxListTile(
    activeColor: Colors.white,
    checkColor: Colors.black,
    title: Text(
      exercicio['nome'],
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: exercicio['feito'] ? Colors.white : Colors.black,
        decoration: exercicio['feito']
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ),
    ),
    value: exercicio['feito'],
    onChanged: (value) {
      setState(() {
        exercicio['feito'] = value;
      });

           salvarExercicios();
    },
  ),
 ),
),
);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
