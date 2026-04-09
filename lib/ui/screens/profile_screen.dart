import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../common/app_widgets.dart';
import '../common/top_titles.dart';
import 'login_screen.dart';
import '../../services/profile_service.dart';
import 'weight_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final profileService = ProfileService();

  bool loading = true;

  String goal = "";
  String name = "";
  String email = "";
  double? weight;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final data = await profileService.getProfile();

    setState(() {
      name = data["name"];
      email = data["email"];
      goal = data["goal"] ?? "No goal";
      weight = data["weight"] != null
          ? double.tryParse(data["weight"].toString())
          : null;
      loading = false;
    });
  }

  void changeGoal() async {
    final goals = [
      {"id": 4, "name": "Build muscle"},
      {"id": 5, "name": "Lose weight"},
      {"id": 6, "name": "Gain strength"},
    ];

    final result = await showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: goals.map((g) {
          return ListTile(
            title: Text(g["name"] as String),
            onTap: () => Navigator.pop(context, g),
          );
        }).toList(),
      ),
    );

    if (result != null) {
      await profileService.updateGoal(result["id"] as int);
      setState(() => goal = result["name"] as String);
    }
  }

  void changeWeight() async {
    final controller = TextEditingController(
      text: weight?.toString() ?? "",
    );

    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter weight"),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: "e.g. 82.5",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                Navigator.pop(context, value);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result != null) {
      await profileService.addWeight(result);
      setState(() => weight = result);
    }
  }

  void logout() async {
    await TokenStorage.clearToken();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      children: [

        const TopOnlyTitle(title: 'Profile'),

        const SizedBox(height: 18),

        ProfileCard(
          name: name,
          email: email,
          levelText: goal,
        ),

        const SizedBox(height: 18),

        const SectionTitle('Settings'),

        const SizedBox(height: 12),

        SettingsTile(
          iconBg: const Color(0xFFD9FBF2),
          iconColor: const Color(0xFF009B87),
          icon: Icons.gps_fixed_rounded,
          title: 'Goal',
          subtitle: goal,
          onTap: changeGoal,
        ),

        const SizedBox(height: 12),

        SettingsTile(
          iconBg: const Color(0xFFFFF4DE),
          iconColor: const Color(0xFFFF8A00),
          icon: Icons.monitor_weight_rounded,
          title: 'Weight',
          subtitle: weight != null ? "${weight} kg" : "Not set",
          onTap: changeWeight,
        ),


        const SizedBox(height: 12),

        SettingsTile(
          iconBg: const Color(0xFFE0E7FF),
          iconColor: const Color(0xFF4F46E5),
          icon: Icons.bar_chart_rounded,
          title: 'Weight history',
          subtitle: 'View & edit all records',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WeightHistoryScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 18),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: logout,
          child: const Text("Logout"),
        ),

      ],
    );
  }
}

class ProfileCard extends StatelessWidget {

  final String name;
  final String email;
  final String levelText;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.levelText,
  });

  @override
  Widget build(BuildContext context) {

    return CardShell(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Row(
        children: [

          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              color: Color(0xFF009B87),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 46,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Pill(
                    text: levelText,
                    bg: const Color(0xFFD9FBF2),
                    fg: const Color(0xFF009B87),
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
