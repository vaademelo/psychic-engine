package intelligence.tools;

import Random;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

import intelligence.hero.HeroMind;

class PersonalityTool {

  public static function generateNewPersonality(mind:HeroMind) {
    var numberOfTraits = Random.int(3, 5);//TODO
    var traits = Random.shuffle(Constants.PERSONALITY_TRAITS);
    mind.personality = traits.slice(0, numberOfTraits);
  }

  public static function lowHealthTrigger(mind:HeroMind, trigger:Bool) {
    if (trigger) trace('lowHealthTrigger');
    applyTrigger('lowhealth', mind, trigger);
  }

  public static function injuriesTrigger(mind:HeroMind, trigger:Bool) {
    if (trigger) trace('injuriesTrigger');
    applyTrigger('hasanyinjuries', mind, trigger);
  }

  public static function enemyOnSightTrigger(mind:HeroMind, trigger:Bool) {
    if (trigger) trace('enemyOnSightTrigger');
    applyTrigger('enemyonsight', mind, trigger);
  }

  public static function strongEnemyTrigger(mind:HeroMind, trigger:Bool) {
    if (trigger) trace('strongEnemyTrigger');
    applyTrigger('strongenemy', mind, trigger);
  }

  public static function collectablesOnSightTrigger(mind:HeroMind, trigger:Bool) {
    if (trigger) trace('collectablesOnSightTrigger');
    applyTrigger('collectablesonsight', mind, trigger);
  }

  public static function holdingCollectablesTrigger(mind:HeroMind, trigger:Bool) {
    if (trigger) trace('holdingCollectablesTrigger');
    applyTrigger('holdingcollectables', mind, trigger);
  }

  public static function alliesNearByTrigger(mind:HeroMind, trigger:Bool) {
    if (trigger) trace('alliesNearByTrigger');
    applyTrigger('alliesnearby', mind, trigger);
  }

  public static function applyTrigger(triggerName:String, mind:HeroMind, value:Bool) {
    for (trait in mind.personality) {
      var trigger = Lambda.find(trait.effects, function (effect) {
        return effect.trigger == triggerName;
      });
      trace(value ? trigger.trueEffect : trigger.falseEffect);
    }
  }

}
