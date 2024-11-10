import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  const RecentTransactions({super.key,required this.text1,required this.text2,required this.text3,required this.text4});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: const Color(0xfff3f3f3),
                                                ),
                                           child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              Text(text1,style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 6,),
                                              Text(text2,style: const TextStyle(color: Color(0xffb4b4b4),fontSize: 13),
                                              ),
                                                const SizedBox(height: 6,),
                                              Text(text3,style: const TextStyle(color: Color(0xffb4b4b4),fontSize: 13),
                                              )
                                            ],),
                                            
                                            Text(text4,style: const TextStyle(fontWeight: FontWeight.bold),)
                                           ],),)
                                           
                                       ;
  }
}