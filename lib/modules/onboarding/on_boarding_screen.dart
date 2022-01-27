import 'package:flutter/material.dart';
import 'package:shop_app_mansour/models/boarding_model.dart';
import 'package:shop_app_mansour/modules/login/login_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../shared/styles/colors.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);



  final PageController boardController = PageController();

   bool? isLastPage = false ;

  void submit(context){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if(value) {
        navigateAndFinish(context, LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<BoardingModel> boarding = [
      BoardingModel(
          image: 'assets/images/on_bording_1.jpg',
          title: AppLocalizations.of(context)!.on_boarding_title_1,
          body: AppLocalizations.of(context)!.on_boarding_body_1),
      BoardingModel(
          image: 'assets/images/on_bording_1.jpg',
          title: AppLocalizations.of(context)!.on_boarding_title_2,
          body: AppLocalizations.of(context)!.on_boarding_body_2),
      BoardingModel(
          image: 'assets/images/on_bording_1.jpg',
          title: AppLocalizations.of(context)!.on_boarding_title_3,
          body: AppLocalizations.of(context)!.on_boarding_body_3),
    ];

    return Scaffold(
      appBar: AppBar(actions: [defaultTextButton(text: AppLocalizations.of(context)!.skip, onPressed: () => submit(context))],),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(onPageChanged: (page){
                if(page == boarding.length-1 ){
                  isLastPage = true ;
                }else{
                  isLastPage = false ;
                }
              },
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (ctx, index) => buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 10.0,
                    expansionFactor: 4.0,
                    dotWidth: 10.0,
                    spacing: 5.0,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if(isLastPage!) {
                      submit(context);
                    }else{
                    boardController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn);}
                  },
                  child: const Icon(Icons.arrow_forward_ios_outlined),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
