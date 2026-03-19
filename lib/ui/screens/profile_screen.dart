import 'package:flutter/material.dart';
import '../../services/settings_service.dart';
import '../../services/token_storage.dart';
import '../common/app_widgets.dart';
import '../common/top_titles.dart';
import 'login_screen.dart';
import '../../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final profileService = ProfileService();

  bool loading = true;

  String goal = "Build muscle";
  String units = "Kilograms (kg)";
  String theme = "Light";

  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    loadSettings();
    loadProfile();
  }

  void loadProfile() async {

    final data = await profileService.getProfile();

    setState(() {
      name = data["name"];
      email = data["email"];
      goal = data["goal"];
      loading = false;
    });

  }

  void loadSettings() async {
    goal = await SettingsService.getGoal();
    units = await SettingsService.getUnits();
    theme = await SettingsService.getTheme();
    setState(() {});
  }

  void changeGoal() async {

    final result = await showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          ListTile(
            title: const Text("Build muscle"),
            onTap: () => Navigator.pop(context, "Build muscle"),
          ),

          ListTile(
            title: const Text("Lose weight"),
            onTap: () => Navigator.pop(context, "Lose weight"),
          ),

          ListTile(
            title: const Text("Gain strength"),
            onTap: () => Navigator.pop(context, "Gain strength"),
          ),

        ],
      ),
    );

    if (result != null) {
      await SettingsService.setGoal(result);
      setState(() => goal = result);
    }
  }

  void changeUnits() async {

    final result = await showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          ListTile(
            title: const Text("Kilograms (kg)"),
            onTap: () => Navigator.pop(context, "Kilograms (kg)"),
          ),

          ListTile(
            title: const Text("Pounds (lbs)"),
            onTap: () => Navigator.pop(context, "Pounds (lbs)"),
          ),

        ],
      ),
    );

    if (result != null) {
      await SettingsService.setUnits(result);
      setState(() => units = result);
    }
  }

  void changeTheme() async {

    final result = await showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          ListTile(
            title: const Text("Light"),
            onTap: () => Navigator.pop(context, "Light"),
          ),

          ListTile(
            title: const Text("Dark"),
            onTap: () => Navigator.pop(context, "Dark"),
          ),

        ],
      ),
    );

    if (result != null) {
      await SettingsService.setTheme(result);
      setState(() => theme = result);
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
          title: 'Goals',
          subtitle: goal,
          onTap: changeGoal,
        ),

        const SizedBox(height: 12),

        SettingsTile(
          iconBg: const Color(0xFFF1E6FF),
          iconColor: const Color(0xFF8E2BFF),
          icon: Icons.scale_rounded,
          title: 'Units',
          subtitle: units,
          onTap: changeUnits,
        ),

        const SizedBox(height: 12),

        SettingsTile(
          iconBg: const Color(0xFFDCEBFF),
          iconColor: const Color(0xFF2563EB),
          icon: Icons.dark_mode_rounded,
          title: 'Theme',
          subtitle: theme,
          onTap: changeTheme,
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