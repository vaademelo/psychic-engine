package utils;

// Character enums //
/////////////////////

enum TeamSide {
  heroes;
  monsters;
}

enum BodyKind {
  fur;
  metal;
  ecto;
}

enum Trait {
  traitOne;
  traitTwo;
}

enum Emotion {
  peaceful;
  rage;
  antecipation;
  joy;
  trust;
  fear;
  distraction;
  sadness;
  disgust;
}

enum PersonalityTrait {
  adventurous; // less will to go back.
  alert; // more aprehensive to danger
  compassionate; // friends on sight matter a lot
  courageous; // triggered by hard places
  curious; // triggered by treasures and the unkown
  dedicated; focused; hardworking; // focused on the objective
  dramatic; // triggered by harm
  fair; // conceus of the trade-off objective/life
  forgiving; // getting hurt wont trigger him
  friendly; // triggered by friends near by
  heroic; // triggered by friends in danger
  honorable; //wont be triggered by big loot
  humble; // wont be triggered by loot
  individualistic; //triggered by friends near by
  intuitive; //more impact for emotion
  manly; //triggered by danger
  logical; methodical; rational; // less impact of emotion
  methodical; // triggered by surprises
  optimistic; // danger dont affect him to much
  prudent; // danger affect him a lot
  relaxed; // not triggered by surprises
  responsible; //
  selfless; // triggered by others situations
  selfCritical; // triggered by battle results
  selfDenying; // triggered by danger
  selfSufficent; // triggered by treasure, not triggered by danger
  sensitive; // sensitive to any trigger
  sentimental; // more weight to emotions and
  sympathetic; //
}

// Treasure enums //
////////////////////

enum TreasureKind {
  food;
  item;
}

// WorldMap enums //
////////////////////

enum ZoneKind {
  starter;
  normal;
  intense;
}

enum ZoneInfo {
  kind;
  coordX;
  coordY;
  nMonsters;
  nTreasures;
  nFood;
}

enum TileContentKind {
  empty;
  hero;
  monster;
  food;
  treasure;
}

// Visual Effects enums //
//////////////////////////

enum BattleEffectKind {
  hit;
  crit;
  fail;
  kill;
}

class Constants {

  public static var HUD_BORDER:Int = 15;
  public static var TILE_SIZE:Int = 48;
  public static var UNIT_SPEED:Int = 1000;
  public static var BATTLE_EFFECT_TIME:Int = 1;
  public static var ZONE_SIZE:Int = 7;

}
