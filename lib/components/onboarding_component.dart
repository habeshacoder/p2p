import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';

class OnboardingComponent extends StatelessWidget {
  const OnboardingComponent({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    this.setCurrentPage,
  }) : super(key: key);

  final VoidCallback? setCurrentPage;
  final String title;
  final String description;
  final String image;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'H',
                  style: TextStyle(
                      color: P2pAppColors.black,
                      fontSize: P2pFontSize.p2p35,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'O',
                  style: TextStyle(
                      color: P2pAppColors.yellow,
                      fontSize: P2pFontSize.p2p35,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'W P2P ',
                  style: TextStyle(
                    color: P2pAppColors.black,
                    fontSize: P2pFontSize.p2p35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'W',
                  style: TextStyle(
                    color: P2pAppColors.black,
                    fontSize: P2pFontSize.p2p35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'O',
                  style: TextStyle(
                    color: P2pAppColors.yellow,
                    fontSize: P2pFontSize.p2p35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'RKS?',
                  style: TextStyle(
                    color: P2pAppColors.black,
                    fontSize: P2pFontSize.p2p35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Image(
              image: AssetImage(
                'assets/images/$image',
              ),
              height: size * 0.4,
              width: size * 0.4,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: P2pAppColors.black,
                fontSize: P2pFontSize.p2p21,
                height: 1.5,
                fontFamily: P2pAppFontsFamily.descriptionTexts.fontFamily,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: P2pSizedBox.fromBottomOfDevice),
          Text(
            textAlign: TextAlign.justify,
            description,
            style: TextStyle(
              color: P2pAppColors.normal,
              fontSize: P2pFontSize.p2p21,
              height: 1.2,
              fontFamily: P2pAppFontsFamily.descriptionTexts.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
