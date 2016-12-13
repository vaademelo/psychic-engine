package gameData;

import Random;

import utils.Constants;
import gameData.Character;

class UserData {

  public static var goldTotal:Int;
  public static var goldGoal:Int;
  public static var heroes:Array<Character>;
  public static var treasures:Array<Treasure>;

  public static function loadUserData() {
    treasures = new Array<Treasure>();

    //TODO: Temp Solution for testing
    for (i in 0...3) {
      var treasure = new Treasure();
      treasures.push(treasure);
    }

    if (goldTotal == null) goldTotal = 30;
    if (heroes == null) {
      heroes = new Array<Character>();
      for (i in 0...3) {
        var char = new Character(TeamSide.heroes);
        heroes.push(char);
      }
    }
    for (hero in heroes) {
      hero.setRandomRelationShips(heroes);
    }
  }

}
