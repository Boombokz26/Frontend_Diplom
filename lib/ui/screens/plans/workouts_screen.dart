import 'package:flutter/material.dart';
import '../../../services/workout_service.dart';
import '../../common/top_titles.dart';
import 'create_workout_plan_screen.dart';
import 'workout_plan_details_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {

  final WorkoutService workoutService = WorkoutService();

  List workouts = [];
  List filteredWorkouts = [];

  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {

    final data = await workoutService.getWorkoutPlans();

    setState(() {
      workouts = data;
      filteredWorkouts = data;
      isLoading = false;
    });

  }

  void applyFilters(String value){

    searchQuery = value;

    final result = workouts.where((plan)=>
        plan["name"]
            .toLowerCase()
            .contains(value.toLowerCase())).toList();

    setState(() {
      filteredWorkouts = result;
    });

  }

  Future<void> clonePlan(int id) async {

    await workoutService.clonePlan(id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Plan cloned")),
    );

    loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final myPlans =
    filteredWorkouts.where((p) => p["User_id"] != null).toList();

    final templates =
    filteredWorkouts.where((p) => p["User_id"] == null).toList();

    return Scaffold(

      backgroundColor: const Color(0xFFF1F5F9),

      floatingActionButton: FloatingActionButton.extended(

        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateWorkoutPlanScreen(),
            ),
          );

          loadWorkouts();
        },

        icon: const Icon(Icons.add),

        label: const Text("New Plan"),

        backgroundColor: const Color(0xFF6366F1),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF3B82F6),
                ],
              ),

              borderRadius: BorderRadius.circular(26),
            ),

            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Workouts",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height:6),

                Text(
                  "Build and manage your training",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize:16,
                  ),
                )

              ],
            ),
          ),

          const SizedBox(height:24),

          /// SEARCH
          TextField(

            decoration: InputDecoration(

              hintText: "Search workouts...",

              prefixIcon: const Icon(Icons.search),

              filled: true,
              fillColor: Colors.white,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),

            ),

            onChanged: applyFilters,
          ),

          const SizedBox(height:28),

          /// MY PLANS
          if(myPlans.isNotEmpty)...[

            const SectionTitle("My Plans"),

            const SizedBox(height:16),

            ...myPlans.map((plan)=>PlanCard(
              plan: plan,
              isTemplate: false,
              onClone: clonePlan,
            )),

            const SizedBox(height:28),

          ],

          /// DISCOVER PLANS
          if(templates.isNotEmpty)...[

            const SectionTitle("Discover Plans"),

            const SizedBox(height:16),

            ...templates.map((plan)=>PlanCard(
              plan: plan,
              isTemplate: true,
              onClone: clonePlan,
            )),

          ]

        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {

  final String title;

  const SectionTitle(this.title,{super.key});

  @override
  Widget build(BuildContext context) {

    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PlanCard extends StatelessWidget {

  final Map plan;
  final bool isTemplate;
  final Function(int) onClone;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isTemplate,
    required this.onClone,
  });

  @override
  Widget build(BuildContext context) {

    final colors = [
      const Color(0xFFE0F2FE),
      const Color(0xFFDCFCE7),
      const Color(0xFFFFEDD5),
      const Color(0xFFFCE7F3),
      const Color(0xFFEDE9FE),
    ];

    final iconColors = [
      const Color(0xFF0284C7),
      const Color(0xFF16A34A),
      const Color(0xFFEA580C),
      const Color(0xFFDB2777),
      const Color(0xFF7C3AED),
    ];

    final index =
        (plan["plan_id"] ?? 0) % colors.length;

    return Padding(
      padding: const EdgeInsets.only(bottom:18),

      child: InkWell(

        borderRadius: BorderRadius.circular(22),

        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkoutPlanDetailsScreen(
                planId: plan["plan_id"],
                title: plan["name"],
              ),
            ),
          );

        },

        child: Container(

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 18,
                offset: const Offset(0,8),
              )
            ],

          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              Row(
                children: [

                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Icon(
                      Icons.fitness_center,
                      color: iconColors[index],
                    ),
                  ),

                  const SizedBox(width:12),

                  Expanded(
                    child: Text(
                      plan["name"] ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if(isTemplate)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal:10,
                          vertical:6
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Row(
                        children: [

                          Icon(
                            Icons.auto_awesome,
                            size:14,
                            color: Color(0xFF0284C7),
                          ),

                          SizedBox(width:4),

                          Text(
                            "Template",
                            style: TextStyle(
                              color: Color(0xFF0284C7),
                              fontSize:11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),
                    )

                ],
              ),

              const SizedBox(height:16),

              /// STATS
              Row(
                children: [

                  Text(
                    "${plan["exercises_count"] ?? 0} exercises",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize:16,
                      color: Color(0xFF475569),
                    ),
                  ),

                  const Spacer(),

                  if(isTemplate)
                    TextButton.icon(

                      onPressed: (){
                        onClone(plan["plan_id"]);
                      },

                      icon: const Icon(
                        Icons.copy_rounded,
                        size:18,
                        color: Color(0xFF6366F1),
                      ),

                      label: const Text(
                        "Clone",
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal:12,
                          vertical:8,
                        ),
                        backgroundColor:
                        const Color(0xFFF1F5FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                    )

                ],
              ),

            ],
          ),

        ),
      ),
    );
  }
}