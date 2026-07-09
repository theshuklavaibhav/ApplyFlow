import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'job_list_screen.dart';
import 'analytics_screen.dart';
import 'ai_screen.dart';
import 'add_edit_job_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    JobListScreen(),
    AnalyticsScreen(),
    AiScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      // FAB — opens add job screen
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditJobScreen()),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 26),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded,
                    label: 'Home', index: 0, currentIndex: _currentIndex,
                    onTap: () => setState(() => _currentIndex = 0)),
                _NavItem(icon: Icons.work_outline, activeIcon: Icons.work_rounded,
                    label: 'Jobs', index: 1, currentIndex: _currentIndex,
                    onTap: () => setState(() => _currentIndex = 1)),
                _NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded,
                    label: 'Stats', index: 2, currentIndex: _currentIndex,
                    onTap: () => setState(() => _currentIndex = 2)),
                _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome,
                    label: 'AI', index: 3, currentIndex: _currentIndex,
                    onTap: () => setState(() => _currentIndex = 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon, required this.activeIcon, required this.label,
    required this.index, required this.currentIndex, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.purpleGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(isActive ? activeIcon : icon,
                size: 20,
                color: isActive ? Colors.white : AppColors.textMuted),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.plusJakartaSans(
                fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
              )),
            ],
          ],
        ),
      ),
    );
  }
}
