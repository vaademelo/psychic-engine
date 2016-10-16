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
