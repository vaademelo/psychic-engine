package gameData;

import Random;

import utils.Constants;
import gameData.Character;

class UserData {

  public static var goldTotal:Int;
  public static var goldGoal:Int;
  public static var heroes:Array<Character>;
  public static var treasures:Array<Treasure>;
  public static var numberOfMissions:Int = 0;

  public static function loadUserData() {
    if (treasures == null) {
      treasures = new Array<Treasure>();
      for (i in 0...3) {
        var treasure = new Treasure(true);
        treasures.push(treasure);
      }
    }

    if (goldTotal == null) goldTotal = 30;
    if (heroes == null) {
      heroes = new Array<Character>();
      for (i in 0...3) {
        createNewHero();
      }
      for (hero in heroes) {
        hero.setRandomRelationShips(heroes);
      }
    }
  }

  public static function createNewHero() {
    var char = new Character(TeamSide.heroes);
    heroes.push(char);
    for (hero in heroes) {
      hero.setRandomRelationShips(heroes);
    }
  }

  public static function resetUserData() {
    treasures = null;
    heroes = null;
    goldTotal = null;
    goldGoal = null;
    numberOfMissions = 0;
  }


}
