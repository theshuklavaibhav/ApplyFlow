// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../models/job_application.dart';
// import '../providers/job_provider.dart';
// import '../utils/constants.dart';
// import 'status_chip.dart';

// class JobCard extends StatelessWidget {
//   final JobApplication job;
//   final VoidCallback onTap; 

//   const JobCard({super.key , required this.job , required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = AppColors.statusColor(job.status) ; 
//     final jobProvider = context.watch<JobProvider>() ;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: AppColors.border) ,
//           borderRadius: BorderRadius.circular(10)  
//         ),
//         child: Row(
//           children: [
//             // This is the Signature "pipeline" elements from design ---
//             // The colored bar instantly tells you status of your job application without reading anything
//             Container(width: 4 , height: 64, color: statusColor,), 
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 11) , 
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                           Text(job.company,
//                             style: TextStyle(
//                               fontSize: 30 , 
//                               fontWeight: FontWeight.bold , 
//                               color: AppColors.ink ,
//                             ),
//                           ),
//                           StatusChip(status: job.status) , 
//                       ],
//                     ) , 
//                     const SizedBox(height: 5,),
//                     Text(job.roleTitle,
//                       style: TextStyle(
//                         color: AppColors.textSecondary,
//                         fontSize: 12
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Icon(Icons.calendar_today_outlined , size: 11, color: AppColors.textMuted,),
//                         const SizedBox(width: 4,),
//                         Text(job.appliedDate != null ? 'Applied ${DateFormat('MMM d').format(job.appliedDate!)}' : 'No date set',),
//                         Expanded(
//                           child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 IconButton(
//                                   onPressed: (){
//                                       jobProvider.deleteJob(job.id) ; 
//                                   } ,
//                                   icon: Icon(Icons.delete_forever),
//                                 )
//                               ],
//                           )
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ) ,  
//           ],
//         ),
//       ),
//     );
//   }
// }
