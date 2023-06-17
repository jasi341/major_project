import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:major_project/color_pallete/pallete.dart';

class FeatureBox extends StatelessWidget {

  final Color color;
  final String header;
  final String description;
  const FeatureBox({super.key, required this.color, required this.header, required this.description});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8
      ).copyWith(left:10,right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
            Radius.circular(15)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  header,
                style: GoogleFonts.robotoSerif(
                    color: Pallete.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                description,
                style: GoogleFonts.robotoSerif(
                    color: Pallete.blackColor,
                    fontStyle: FontStyle.italic,
                  fontSize: 16
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
