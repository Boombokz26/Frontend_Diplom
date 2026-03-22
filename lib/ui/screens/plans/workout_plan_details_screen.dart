import 'package:flutter/material.dart';
import '../../../services/workout_service.dart';
import '../Exercise/exercise_selection_screen.dart';
import 'active_workout_screen.dart';

class WorkoutPlanDetailsScreen extends StatefulWidget {
  final int planId;
  final String title;

  const WorkoutPlanDetailsScreen({
    super.key,
    required this.planId,
    required this.title,
  });

  @override
  State<WorkoutPlanDetailsScreen> createState() =>
      _WorkoutPlanDetailsScreenState();
}

class _WorkoutPlanDetailsScreenState
    extends State<WorkoutPlanDetailsScreen> {

  final WorkoutService workoutService = WorkoutService();

  List exercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {

    final data = await workoutService.getPlanExercises(widget.planId);

    setState(() {
      exercises = data;
      isLoading = false;
    });

  }

  int get totalSets {
    int sum = 0;

    for (var e in exercises) {
      sum += (e["sets"] ?? 0) as int;
    }

    return sum;
  }


  void showAddExerciseDialog() {

    final sets = TextEditingController(text: "3");
    final reps = TextEditingController(text: "10");
    final weight = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Add Exercise"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: sets,
                decoration: const InputDecoration(labelText: "Sets"),
              ),

              TextField(
                controller: reps,
                decoration: const InputDecoration(labelText: "Reps"),
              ),

              TextField(
                controller: weight,
                decoration: const InputDecoration(labelText: "Weight"),
              ),

            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                await workoutService.addExercise(
                  planId: widget.planId,
                  exerciseId: 1,
                  sets: int.parse(sets.text),
                  reps: int.parse(reps.text),
                  targetWeight: int.parse(weight.text),
                );

                Navigator.pop(context);
                loadExercises();
              },
              child: const Text("Add"),
            )

          ],
        );

      },
    );
  }

  void showEditExerciseDialog(Map exercise) {

    final sets = TextEditingController(
        text: exercise["sets"].toString());

    final reps = TextEditingController(
        text: exercise["reps"].toString());

    final weight = TextEditingController(
        text: exercise["target_weight"].toString());

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Edit Exercise"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: sets,
                decoration: const InputDecoration(labelText: "Sets"),
              ),

              TextField(
                controller: reps,
                decoration: const InputDecoration(labelText: "Reps"),
              ),

              TextField(
                controller: weight,
                decoration: const InputDecoration(labelText: "Weight"),
              ),

            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                await workoutService.updateExercise(
                  planId: widget.planId,
                  planExerciseId: exercise["plan_exercise_id"],
                  sets: int.parse(sets.text),
                  reps: int.parse(reps.text),
                  targetWeight: int.parse(weight.text),
                );

                Navigator.pop(context);
                loadExercises();
              },
              child: const Text("Save"),
            )

          ],
        );

      },
    );
  }


  Future<void> deleteExercise(int id) async {

    await workoutService.removeExercise(
      planId: widget.planId,
      planExerciseId: id,
    );

    loadExercises();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF1F5F9),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add),
        onPressed: () async {

          final exerciseId = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ExerciseSelectionScreen(),
            ),
          );

          if (exerciseId != null) {

            await workoutService.addExercise(
              planId: widget.planId,
              exerciseId: exerciseId,
              sets: 3,
              reps: 10,
              targetWeight: 0,
            );

            loadExercises();
          }

        },
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [


          Container(

            padding: const EdgeInsets.fromLTRB(24,60,24,28),

            width: double.infinity,

            decoration: const BoxDecoration(

              gradient: LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF2563EB),
                ],
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),

            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back,color:Colors.white),
                    ),

                    const SizedBox(width:6),

                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize:26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height:18),

                Row(
                  children: [

                    _HeaderStat(
                      value: exercises.length.toString(),
                      label: "Exercises",
                    ),

                    const SizedBox(width:18),

                    _HeaderStat(
                      value: totalSets.toString(),
                      label: "Total sets",
                    ),

                  ],
                ),
                const SizedBox(height:20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed: () async {

                      final sessionId =
                      await workoutService.startWorkout(widget.planId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActiveWorkoutScreen(
                            sessionId: sessionId,
                          ),
                        ),
                      );

                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4F46E5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      "Start Workout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),

          const SizedBox(height:16),

          /// LIST
          Expanded(
            child: ReorderableListView.builder(

              padding: const EdgeInsets.symmetric(horizontal:16),

              itemCount: exercises.length,

              onReorder: (oldIndex,newIndex) async {

                if(newIndex>oldIndex){
                  newIndex--;
                }

                final item = exercises.removeAt(oldIndex);
                exercises.insert(newIndex,item);

                setState(() {});

                List<int> order = exercises
                    .map<int>((e) => e["plan_exercise_id"])
                    .toList();

                await workoutService.reorderExercises(
                  planId: widget.planId,
                  order: order,
                );
              },

              itemBuilder: (context,index){

                final exercise = exercises[index];

                return ExerciseCard(
                  key: ValueKey(exercise["plan_exercise_id"]),
                  exercise: exercise,
                  index: index,
                  onEdit: () => showEditExerciseDialog(exercise),
                  onDelete: () => deleteExercise(
                      exercise["plan_exercise_id"]),
                );

              },
            ),
          ),

        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {

  final String value;
  final String label;

  const _HeaderStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal:16,
        vertical:12,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        children: [

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize:20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height:2),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize:12,
            ),
          )

        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {

  final Map exercise;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    final iconColors = [
      const Color(0xFFE0F2FE),
      const Color(0xFFDCFCE7),
      const Color(0xFFFFEDD5),
      const Color(0xFFFCE7F3),
      const Color(0xFFEDE9FE),
    ];

    final iconColor = iconColors[index % iconColors.length];

    return Container(

      margin: const EdgeInsets.only(bottom:16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0,6),
          )
        ],
      ),

      child: Padding(

        padding: const EdgeInsets.all(18),

        child: Row(
          children: [

            Container(
              width:34,
              height:34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${index+1}",
                style: const TextStyle(
                    color:Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            const SizedBox(width:12),

            Container(
              width:52,
              height:52,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.fitness_center),
            ),

            const SizedBox(width:16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    exercise["exercise_name"] ?? "",
                    style: const TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height:8),

                  Text(
                    "${exercise["sets"]} sets • ${exercise["reps"]} reps",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                ],
              ),
            ),

            Column(
              children: [

                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),

                IconButton(
                  icon: const Icon(Icons.delete,color: Colors.red),
                  onPressed: onDelete,
                ),

              ],
            ),

            Container(

              padding: const EdgeInsets.symmetric(
                  horizontal:14,
                  vertical:10
              ),

              decoration: BoxDecoration(

                gradient: const LinearGradient(
                  colors:[
                    Color(0xFF6366F1),
                    Color(0xFF4F46E5),
                  ],
                ),

                borderRadius: BorderRadius.circular(14),

              ),

              child: Column(
                children: [

                  Text(
                    "${exercise["target_weight"] ?? 0}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:16,
                    ),
                  ),

                  const Text(
                    "kg",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize:11,
                    ),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}