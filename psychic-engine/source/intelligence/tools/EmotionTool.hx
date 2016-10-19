package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

class EmotionTool {

  public static function lootMultiplier(unit:Unit):Int {
    switch (unit.mind.currentEmotion) {
      case Emotion.rage:
        return 1;
      case Emotion.antecipation:
        return 1;
      case Emotion.joy:
        return 1;
      case Emotion.trust:
        return 1;
      case Emotion.fear:
        return 1;
      case Emotion.distraction:
        return 1;
      case Emotion.sadness:
        return 1;
      case Emotion.disgust:
        return 1;
      default:
        return 1;
    }
  }

  public static function battleMultiplier(unit:Unit):Int {
    switch (unit.mind.currentEmotion) {
      case Emotion.rage:
        return 1;
      case Emotion.antecipation:
        return 1;
      case Emotion.joy:
        return 1;
      case Emotion.trust:
        return 1;
      case Emotion.fear:
        return 1;
      case Emotion.distraction:
        return 1;
      case Emotion.sadness:
        return 1;
      case Emotion.disgust:
        return 1;
      default:
        return 1;
    }
  }
}
