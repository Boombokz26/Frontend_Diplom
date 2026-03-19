import 'package:flutter/material.dart';
import '../Exercise/exercise_detail_screen.dart';
import '../Exercise/create_exercise_screen.dart';
import '../../common/top_titles.dart';
import '../../../services/exercise_service.dart';
import '../../../services/category_service.dart';
import '../../../services/goals_service.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {

  final exerciseService = ExerciseService();
  final categoryService = CategoryService();
  final goalService = GoalsService();

  List exercises = [];
  List goals = [];
  List categories = [];

  bool loading = true;

  String? selectedCategory;
  String? selectedGoal;

  String search = "";

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future loadInitialData() async {

    final ex = await exerciseService.getExercises();
    final g = await goalService.getGoals();
    final c = await categoryService.getCategories();

    setState(() {
      exercises = ex;
      goals = g;
      categories = c;
      loading = false;
    });

  }

  Future loadExercises() async {

    final res = await exerciseService.getExercises(
      categoryId: selectedCategory,
      goalId: selectedGoal,
    );

    setState(() {
      exercises = res;
    });

  }

  List filteredExercises() {

    if (search.isEmpty) return exercises;

    return exercises.where((e) {
      return e["name"]
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase());
    }).toList();

  }

  Map<String, List> groupedExercises() {

    final filtered = filteredExercises();

    Map<String, List> groups = {};

    for (var e in filtered) {

      final category = e["category_name"] ?? "Other";

      if (!groups.containsKey(category)) {
        groups[category] = [];
      }

      groups[category]!.add(e);

    }

    return groups;

  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final grouped = groupedExercises();

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: () async {

          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateExerciseScreen(),
            ),
          );

          if (created == true) {
            loadExercises();
          }

        },
        child: const Icon(Icons.add),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 80),
        children: [

          const TopTitle(
            title: "Exercises",
            subtitle: "Browse exercises by muscle group",
          ),

          const SizedBox(height: 20),

          // SEARCH
          TextField(
            decoration: InputDecoration(
              hintText: "Search exercises...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) {
              setState(() {
                search = v;
              });
            },
          ),

          const SizedBox(height: 18),

          // FILTERS
          Row(
            children: [

              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true, // ✅ ВАЖНО
                  hint: const Text("Category"),
                  value: selectedCategory,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("All categories"),
                    ),
                    ...categories.map((c) {
                      return DropdownMenuItem<String>(
                        value: c["id"].toString(),
                        child: Text(
                          c["name"],
                          overflow: TextOverflow.ellipsis, // ✅
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (v) {
                    setState(() {
                      selectedCategory = v;
                    });
                    loadExercises();
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: const Text("Goal"),
                  value: selectedGoal,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("All goals"),
                    ),
                    ...goals.map((g) {
                      return DropdownMenuItem<String>(
                        value: g["id"].toString(),
                        child: Text(
                          g["name"],
                          overflow: TextOverflow.ellipsis, // ✅
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (v) {
                    setState(() {
                      selectedGoal = v;
                    });
                    loadExercises();
                  },
                ),
              ),

            ],
          ),

          const SizedBox(height: 26),



          ...grouped.entries.map((entry) {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 12),

                ...entry.value.map((e) {

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF818CF8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: ListTile(

                        leading: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                        ),

                        title: Text(
                          e["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),

                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExerciseDetailScreen(
                                exercise: e,
                              ),
                            ),
                          );
                        },

                      ),
                    ),
                  );

                }).toList(),

                const SizedBox(height: 22),

              ],
            );

          })

        ],
      ),
    );
  }
}