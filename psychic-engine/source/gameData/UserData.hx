package gameData;

import Random;

import utils.Constants;
import gameData.Character;

class UserData {

  public static var foodTotal:Int;
  public static var heroes:Array<Character>;
  public static var treasures:Array<Treasure>;
  public static var foodGoal:Int;
  public static var treasureGoal:Int;

  public static function loadUserData() {
    //TODO: Try to load from a saved data

    if (foodTotal == null) foodTotal = Random.int(10, 30);
    if (heroes == null) {
      heroes = new Array<Character>();
      for (i in 0...3) {
        var char = new Character(TeamSide.heroes);
        heroes.push(char);
      }
    }
    //TODO: treasures data
  }

}
