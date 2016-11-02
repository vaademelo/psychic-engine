package utils;

import openfl.Assets;

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
  name;
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

typedef PersonalityTrait = {
  name : String,
  effects: Array<TriggerEffect>
}

typedef TriggerEffect = {
  trigger: String,
  trueEffect: Emotion,
  falseEffect: Emotion
}

class Constants {

  public static var HUD_BORDER:Int = 15;
  public static var TILE_SIZE:Int = 48;
  public static var UNIT_SPEED:Int = 1000;
  public static var BATTLE_EFFECT_TIME:Int = 1;
  public static var ZONE_SIZE:Int = 7;

  public static var TRIGGERS:Array<String>;
  public static var PERSONALITY_TRAITS:Array<PersonalityTrait>;

  public static var MAX_LIFE = 4;
  public static var MAX_INJURY = 5;
  public static var MAX_MOVEMENT = 4;
  public static var MAX_VISION = 6;
  public static var MAX_ATACKRANGE = 1;

  public static function setup() {
    var json:String = Assets.getText('assets/data/personalityTraits.json');
    var obj = haxe.Json.parse(json);
    TRIGGERS = obj.triggers;
    PERSONALITY_TRAITS = new Array<PersonalityTrait>();

    for (traitName in Reflect.fields(obj.traits)) {
      var trait:PersonalityTrait = {name: null, effects:[]};
      trait.name = traitName;

      var effects = Reflect.field(obj.traits, traitName);

      for (triggerName in Reflect.fields(effects)) {
        var effect:TriggerEffect = {trigger:null, trueEffect:null, falseEffect:null};
        effect.trigger = triggerName;
        effect.trueEffect = Type.createEnum(Emotion, Reflect.field(effects, triggerName)[0]);
        effect.falseEffect = Type.createEnum(Emotion, Reflect.field(effects, triggerName)[1]);
        trait.effects.push(effect);
      }

      PERSONALITY_TRAITS.push(trait);
    }
  }

}
