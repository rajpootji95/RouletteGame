// import 'package:flutter/material.dart';
//
// class TableRow  extends StatelessWidget {
//   const TableRow({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return TableRow(
//         children: List.generate(9,
//                 (index){
//               final number = index+10;
//               return GestureDetector(
//                 onTap: () {
//                   if( selectedNumber != number) {
//                     playAudio(SoundSource.numberClickSoundPath);
//                   }
//                   setState(() {
//                     selectedNumber = number;
//                   });
//
//                 },
//                 child: Container(
//                   height: 32,
//                   width:32 ,
//                   decoration: BoxDecoration(
//                     // color: const Color(0XFF930000),
//                     //   border:
//                     // GradientBoxBorder(
//                     //     width: selectedNumber == number ?0:1.5,
//                     //     gradient: LinearGradient(colors: [Colors.orange,colors.borderColorLight,colors.darkPinkColor,colors.borderColorLight])),
//                     // Border.all(
//                     //   color:
//                     //   colors.borderColorDark, // Highlight selected number
//                     //   width: selectedNumber == number ?1:2.0,
//                     // ),
//                       boxShadow: [
//                         selectedNumber == number ?
//                         BoxShadow(
//                             color: Colors.orange.shade900,
//                             blurRadius: 3,
//                             spreadRadius: 2
//                         ):
//                         const BoxShadow(
//                             color: Colors.transparent
//                         )
//                       ]
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${numberSeries[index+9]}', // Accessing number from numberSeries list
//                       style: TextStyle(
//                           color: colors.borderColorDark,
//                           fontSize: 22.0,
//                           fontFamily: "digital"
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//     );
//   }
// }
