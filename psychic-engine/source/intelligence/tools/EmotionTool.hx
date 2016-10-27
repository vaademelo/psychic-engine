package intelligence.tools;

import Random;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

import intelligence.hero.HeroMind;

class EmotionTool {

  public static function generateTokens():Map<Emotion, Float> {
    var emotionWeights = new Map<Emotion, Float>();
    for (emotion in Type.allEnums(Emotion)) {
      emotionWeights[emotion] = 0;
    }
    return emotionWeights;
  }

  public static function amortizeTokens(mind:HeroMind) {
    for (token in mind.emotionWeights) {
      if (token > 0.3) {
        token -= 0.3;
      } else {
        token = 0;
      }
    }
  }

  public static function defineCurrentEmotion(mind:HeroMind) {
    var maxValue:Float = 0;

    mind.currentEmotion = Emotion.peaceful;
    for (emotion in mind.emotionWeights.keys()) {
      if (mind.emotionWeights[emotion] == 0 || emotion == Emotion.peaceful) continue;
      if (mind.emotionWeights[emotion] > maxValue) {
        maxValue = mind.emotionWeights[emotion];
        mind.currentEmotion = emotion;
      } else if (mind.emotionWeights[emotion] == maxValue) {
        mind.currentEmotion = Random.fromArray([emotion, mind.currentEmotion]);
      }
    }
  }

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
