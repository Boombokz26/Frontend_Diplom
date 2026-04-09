import 'package:flutter/material.dart';
import '../../services/profile_service.dart';

class WeightHistoryScreen extends StatefulWidget {
  const WeightHistoryScreen({super.key});

  @override
  State<WeightHistoryScreen> createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends State<WeightHistoryScreen> {
  final service = ProfileService();

  List weights = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadWeights();
  }

  Future<void> loadWeights() async {
    final data = await service.getWeights();

    setState(() {
      weights = data.reversed.toList();
      loading = false;
    });
  }

  void deleteWeight(int id) async {
    await service.deleteWeight(id);
    await loadWeights();
  }

  void editWeight(Map item) async {
    final controller = TextEditingController(
      text: item["weight"].toString(),
    );

    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit weight"),
        content: TextField(
          controller: controller,
          keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                Navigator.pop(context, val);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result != null) {
      await service.updateWeight(item["id"], result);
      await loadWeights();
    }
  }

  void addWeight() async {
    final controller = TextEditingController();

    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add weight"),
        content: TextField(
          controller: controller,
          keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                Navigator.pop(context, val);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );

    if (result != null) {
      await service.addWeight(result);
      await loadWeights();
    }
  }

  String formatDate(String date) {
    final d = DateTime.parse(date);
    return "${d.day}.${d.month}.${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Weight History",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addWeight,
        backgroundColor: const Color(0xFF009B87),
        child: const Icon(Icons.add),
      ),
      body: weights.isEmpty
          ? const Center(
        child: Text(
          "No weight records yet",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: weights.length,
        itemBuilder: (context, index) {
          final item = weights[index];

          return Dismissible(
            key: ValueKey(item["id"]),
            direction: DismissDirection.endToStart,

            confirmDismiss: (_) async {
              return await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete weight"),
                  content: const Text("Are you sure you want to delete this record?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },

            onDismissed: (_) => deleteWeight(item["id"]),

            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withValues(alpha: 0.05),
                  )
                ],
              ),
              child: Row(
                children: [

                  // Иконка
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9FBF2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monitor_weight,
                      color: Color(0xFF009B87),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Вес
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item["weight"]} kg",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(item["date"]),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✏️ редактировать
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => editWeight(item),
                  ),

                  // 🗑 удалить (кнопка)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete weight"),
                          content: const Text("Are you sure?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        deleteWeight(item["id"]);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}