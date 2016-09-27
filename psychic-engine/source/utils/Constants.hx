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

class Constants {

  public static var TILESIZE:Int = 48;

  public static var UNITSPEED:Int = 1000;

}
