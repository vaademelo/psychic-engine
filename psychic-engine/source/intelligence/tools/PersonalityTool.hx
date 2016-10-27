package intelligence.tools;

import Random;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

import intelligence.hero.HeroMind;

class PersonalityTool {

  public static function generateNewPersonality():Array<PersonalityTrait> {
    var personality = new Array<PersonalityTrait>();
    var numberOfTraits = Random.int(3, 5);//TODO
    var traits = Random.shuffle(Constants.PERSONALITY_TRAITS);
    personality = traits.slice(0, numberOfTraits);
    return personality;
  }

  public static function lowHealthTrigger(mind:HeroMind, trigger:Bool) {
    applyTrigger('lowhealth', mind, trigger, 1);
  }

  public static function injuriesTrigger(mind:HeroMind, trigger:Bool) {
    applyTrigger('hasanyinjuries', mind, trigger, 2);
  }

  public static function enemyOnSightTrigger(mind:HeroMind, trigger:Bool) {
    applyTrigger('enemyonsight', mind, trigger, 1);
  }

  public static function strongEnemyTrigger(mind:HeroMind, trigger:Bool) {
    applyTrigger('strongenemy', mind, trigger, 2);
  }

  public static function collectablesOnSightTrigger(mind:HeroMind, trigger:Bool) {
    applyTrigger('collectablesonsight', mind, trigger, 1);
  }

  public static function holdingCollectablesTrigger(mind:HeroMind, trigger:Bool) {
    applyTrigger('holdingcollectables', mind, trigger, 1);
  }

  public static function alliesNearByTrigger(mind:HeroMind, trigger:Bool) {
    applyTrigger('alliesnearby', mind, trigger, 1);
  }

  public static function applyTrigger(triggerName:String, mind:HeroMind, value:Bool, weight:Float) {
    for (trait in mind.personality) {
      var trigger = Lambda.find(trait.effects, function (effect) {
        return effect.trigger == triggerName;
      });
      mind.emotionWeights[value ? trigger.trueEffect : trigger.falseEffect] += weight;
    }
  }

}
