import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.lable,
    required this.count,
    required this.color,
  });

  final String lable;
  final int count;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color
              ),
            ),
            Text(lable ,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary
              ),
            )
          ],
        ),
      ),
    ); 
  }
}
