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
      this.imageSource = "assets/images/bodies/h" + Std.string(bodyKind) + ".png";

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
      this.imageSource = "assets/images/bodies/e" + Std.string(bodyKind) + ".png";

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

}
