package gameData;

import Random;

import flixel.util.typeLimit.OneOfTwo;

import utils.MyNameGenerator;
import utils.Constants;

import intelligence.tools.PersonalityTool;

class Character {

  public var team:TeamSide;

  public var hpMax:Int;
  public var injuryMax:Int;
  public var movement:Int;
  public var atackRange:Int;
  public var bodyKind:BodyKind;
  public var hitChance:Map<BodyKind, Float>;
  public var critChance:Map<BodyKind, Float>;
  public var vision:Int;

  public var name:String;
  public var imageSource:String;
  public var relationList:Map<Character, Int>;
  public var personality:Array<PersonalityTrait>;
  public var goalTile:Array<Int>;
  public var goalChar:Character;

  public function new(team:TeamSide) {
    this.team = team;

    this.atackRange = 1;
    if(team == TeamSide.heroes) {
      this.hpMax = Random.int(3, 4);
      this.injuryMax = Random.int(3, 5);
      this.movement = Random.int(3, 4);
      this.bodyKind = Random.enumConstructor(BodyKind);
      this.hitChance = new Map<BodyKind,Float>();
      this.critChance = new Map<BodyKind,Float>();
      this.vision = Random.int(5, 6);
      this.imageSource = "assets/images/bodies/h" + Std.string(bodyKind) + "0" + Random.int(1,8) + ".png";

      /*if (bodyKind == BodyKind.metal){*/
        this.imageSource = "assets/images/bodies/h_metal0" + Random.int(0,8) + ".png";

      /*} else if (bodyKind == BodyKind.fur){
        this.imageSource = "assets/images/bodies/h" + Std.string(bodyKind) + "0" + Random.int(1,8) + ".png";

      } else {
        this.imageSource = "assets/images/bodies/h" + Std.string(bodyKind) + "0" + Random.int(1,8) + ".png";
      }*/

      this.name = MyNameGenerator.generateName();
      this.personality = PersonalityTool.generateNewPersonality();
      this.relationList = new Map<Character, Int>();

      var bodyKinds = Type.allEnums(BodyKind);

      for(body in bodyKinds) {
        this.hitChance[body] = Random.float(0.3, 0.7);
        this.critChance[body] = Random.float(0.0, 0.3);
      }

    } else {
      this.hpMax = Random.int(1, 3);
      this.injuryMax = Random.int(1, 2);
      this.movement = Random.int(1, 2);
      this.bodyKind = Random.enumConstructor(BodyKind);
      this.hitChance = new Map<BodyKind,Float>();
      this.critChance = new Map<BodyKind,Float>();
      this.vision = Random.int(3, 4);

      if (bodyKind == BodyKind.metal){
        this.imageSource = "assets/images/bodies/e_golem0" + Random.int(0,2) + ".png";

      } else if (bodyKind == BodyKind.fur){
        this.imageSource = "assets/images/bodies/e_zombie0" + Random.int(0,2) + ".png";

      } else {
        this.imageSource = "assets/images/bodies/e_ecto0" + Random.int(0,1) + ".png";
      }


      var bodyKinds = Type.allEnums(BodyKind);
      for(body in bodyKinds) {
        this.hitChance[body] = Random.float(0.1, 0.4);
        this.critChance[body] = Random.float(0.0, 0.1);
      }

    }

  }

  public function setRandomRelationShips(friends:Array<Character>) {
    for (friend in friends) {
      if (friend == this) continue;
      setOneRandomRelationShip(friend);
    }
  }

  public function setOneRandomRelationShip(friend:Character) {
    if (this.relationList[friend] == null && friend != this) {
      this.relationList[friend] = Random.int(1, 5);
    }
  }

  public function resetGoals() {
    this.goalTile = null;
    this.goalChar = null;

    for (friend in relationList.keys()) {
      if (UserData.heroes.indexOf(friend) == -1) {
        relationList.remove(friend);
      }
    }
  }


}
