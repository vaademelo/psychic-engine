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

}
