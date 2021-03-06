package intelligence.tools;

import Random;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

import intelligence.HeroMind;

class EmotionTool {

  public static function generateTokens():Map<Emotion, Float> {
    var emotionWeights = new Map<Emotion, Float>();
    for (emotion in Type.allEnums(Emotion)) {
      emotionWeights[emotion] = 0;
    }
    return emotionWeights;
  }

  public static function amortizeTokens(mind:HeroMind) {

    if (mind.emotionsAmortization == null) {
      mind.emotionsAmortization = new Map<Emotion, Float>();
    }
    if (mind.emotionsLastTurn == null) {
      mind.emotionsLastTurn = new Map<Emotion, Float>();
    }
    mind.triggersEffectOnEmotions = new Map<Emotion, Map<String, Float>>();

    for (emotion in mind.emotionWeights.keys()) {

      //for debug analysis
      mind.triggersEffectOnEmotions[emotion] = new Map<String, Float>();
      mind.emotionsLastTurn[emotion] = mind.emotionWeights[emotion];

      if (mind.emotionWeights[emotion] > 0.3) {
        if (emotion == mind.currentEmotion) {
          mind.emotionsAmortization[emotion] = Math.ceil(mind.emotionWeights[emotion]*2/3);
          mind.emotionWeights[emotion] -= Math.ceil(mind.emotionWeights[emotion]*2/3);
        } else {
          mind.emotionsAmortization[emotion] = Math.ceil(mind.emotionWeights[emotion]/3);
          mind.emotionWeights[emotion] -= Math.ceil(mind.emotionWeights[emotion]/3);
        }
      } else {
        mind.emotionsAmortization[emotion] = mind.emotionWeights[emotion];
        mind.emotionWeights[emotion] = 0;
      }
    }
  }

  public static function defineCurrentEmotion(mind:HeroMind) {
    var maxValue:Float = 0;
    mind.lastEmotion = mind.currentEmotion;

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

  public static function emotionFactor(unit:Unit, criteria:String):Float {
    var factor:Float = 1;
    if (unit.mind.currentEmotion == Emotion.peaceful) {
      factor = 1;
    } else {
      var weights:Map<String, Float> = Constants.EMOTION_WEIGHTS[unit.mind.currentEmotion];
      factor = weights.get(criteria);
    }
    return factor;
  }

  public static function applyEmotion(unit:Unit, criteria:String, tileWeights:Map<String, Float>) {
    for (key in tileWeights.keys()) {
      tileWeights[key] *= emotionFactor(unit, criteria);
    }
    return tileWeights;
  }
}
