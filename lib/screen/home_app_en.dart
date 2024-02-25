import 'package:flutter/material.dart';
import 'package:hang_game_project/language.dart';
import 'package:hang_game_project/screen/home_screen.dart';
import 'package:hang_game_project/ui/colors.dart';
import 'package:hang_game_project/ui/widget/figure_image.dart';
import 'package:hang_game_project/ui/widget/letter.dart';
import 'package:hang_game_project/utils/game.dart';
import 'package:quickalert/quickalert.dart';



class HomeApp extends StatefulWidget {

  const HomeApp({Key? key,}) : super(key: key);


  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

   int test = 0 ;
  Game _game = Game();
  Language _language = Language();


  late String randomItem = (_language.wards..shuffle()).first;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(randomItem);
    Game.tries = 0;
    Game.selectedChar= [];


  }

  //choosing the game word


  //Create a list that contains the Alphabet, or you can just copy and paste it


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text("Hangman"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                //let's make the figure widget
                //let's add the images to the asset folder
                //Okey now we will create a Game class
                //Now the figure will be built according to the number of tries
                figureImage(Game.tries >= 0, "assets/hang.png"),
                figureImage(Game.tries >= 1, "assets/head.png"),
                figureImage(Game.tries >= 2, "assets/body.png"),
                figureImage(Game.tries >= 3, "assets/ra.png"),
                figureImage(Game.tries >= 4, "assets/la.png"),
                figureImage(Game.tries >= 5, "assets/rl.png"),
                figureImage(Game.tries >= 6, "assets/ll.png"),
              ],
            ),
          ),

          //Now we will build the Hidden word widget
          //now let's go back to the Game class and add
          // a new variable to store the selected character
          /* and check if it's on the word */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: randomItem.split('')
                .map((e) => letter(e.toUpperCase(),
                !Game.selectedChar.contains(e.toUpperCase())))
                .toList(),
          ),

          //Now let's build the Game keyboard
          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: EdgeInsets.all(8.0),
              children: _language.alphabets.map((e) {
                return RawMaterialButton(
                  onPressed: Game.selectedChar.contains(e)
                      ? null // we first check that we didn't selected the button before
                      : () {
                    setState(()  {
                      Game.selectedChar.add(e);
                      print(Game.selectedChar);
                      if (!randomItem.split('').contains(e.toUpperCase())) {
                        Game.tries++;
                        print(Game.tries);
                        print(e);


                      }
                      if (randomItem.split('').contains(e.toUpperCase())) {


                        test= test+(e.allMatches(randomItem).length);
                        print(test);

                      }

                      if(test == randomItem.length){
                          QuickAlert.show(context: context,
                            type: QuickAlertType.success,
                              barrierDismissible: false,
                            title: 'Good Job',
                            text: 'Success with ${Game.tries} mistakes',
                            onConfirmBtnTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );

                            }
                        );


                      }
                      if(Game.tries>5){
                        QuickAlert.show(
                          context:context,
                          type:QuickAlertType.error,
                            barrierDismissible: false,
                            title: 'You Fail',
                            text: 'Try Another Time',
                            onConfirmBtnTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );

                            }

                        );
                      }

                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fillColor: Game.selectedChar.contains(e)
                      ? Colors.black87
                      : Colors.blue,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
