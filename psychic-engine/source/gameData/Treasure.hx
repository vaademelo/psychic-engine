package gameData;

import Random;

import gameData.Character;

import utils.Constants;

class Treasure {

  public var kind:TreasureKind;
  public var name:String;
  public var effectType:TreasureEffect;
  public var effectDetail:String;
  public var iconSource:String;

  private var used:Bool = false;

  public function new(noRecruit:Bool = false) {
    var rnd = (noRecruit) ? Random.int(1,9) : Random.int(0,9);
    switch rnd {
      case 0:
        this.effectType = TreasureEffect.recruitment;
      case 1, 4, 7:
        this.effectType = TreasureEffect.training;
        this.effectDetail = Std.string(Random.fromArray(Type.allEnums(TreasureTrainingDetail)));
      case 2, 5, 8:
        this.effectType = TreasureEffect.behaviour;
        this.effectDetail = Std.string(Random.fromArray(Type.allEnums(TreasureBehaviouDetail)));
      case 3, 6, 9:
        this.effectType = TreasureEffect.relation;
        this.effectDetail = "Improve Friendship";
    }

  }

  public function convertKind() {
    var rnd = Random.int(1,9);
    switch rnd {
      case 1, 4, 7:
        this.effectType = TreasureEffect.training;
        this.effectDetail = Std.string(Random.fromArray(Type.allEnums(TreasureTrainingDetail)));
      case 2, 5, 8:
        this.effectType = TreasureEffect.behaviour;
        this.effectDetail = Std.string(Random.fromArray(Type.allEnums(TreasureBehaviouDetail)));
      case 3, 6, 9:
        this.effectType = TreasureEffect.relation;
        this.effectDetail = "Improve Friendship";
    }
  }

  public function useTreasure(?char:Character, ?relationChar:Character) {
    if (used) {
      UserData.treasures.remove(this);
      return;
    }
    switch this.effectType {
      case TreasureEffect.recruitment:
        UserData.createNewHero();
      case TreasureEffect.training:
        if (char == null) return;
        switch this.effectDetail {
          case "life":
            char.hpMax ++;
          case "resistence":
            char.injuryMax ++;
          case "speed":
            char.movement ++;
          case "consistency":
            for (key in char.hitChance.keys()) {
              char.hitChance[key] += 0.05;
            }
          case "letal":
            for (key in char.critChance.keys()) {
              char.critChance[key] += 0.01;
            }
          case "observation":
            if (Random.bool()) char.vision ++;
        }
      case TreasureEffect.behaviour:
        if (char == null) return;
        switch this.effectDetail {
          case "discipline":
            doBehaviourEffect(char, Emotion.antecipation, Emotion.distraction);
          case "luck":
            doBehaviourEffect(char, Emotion.distraction, Emotion.antecipation);
          case "party":
            doBehaviourEffect(char, Emotion.joy, Emotion.sadness);
          case "meditation":
            doBehaviourEffect(char, Emotion.sadness, Emotion.joy);
          case "combat":
            doBehaviourEffect(char, Emotion.rage, Emotion.fear);
          case "selfPreservation":
            doBehaviourEffect(char, Emotion.fear, Emotion.rage);
          case "selfAnalysis":
            doBehaviourEffect(char, Emotion.trust, Emotion.disgust);
          case "studingMonsters":
            doBehaviourEffect(char, Emotion.disgust, Emotion.trust);
        }
      case TreasureEffect.relation:
        if (char == null || relationChar == null) return;
        if (char.relationList[relationChar] >= 5) return;
        var rnd = Random.float(0,1);
        if (rnd > 0.6) char.relationList[relationChar] ++;
    }
    UserData.treasures.remove(this);
    used = true;
  }

  public function doBehaviourEffect(char:Character, more:Emotion, less:Emotion) {
    if (Random.bool() && Random.bool()) {
      var foundTrait:PersonalityTrait = Lambda.find(char.personality, function (trait:PersonalityTrait) {
        return Lambda.exists(trait.effects, function (trigger:TriggerEffect) {
          return trigger.trueEffect == less || trigger.falseEffect == less;
        });
      });
      if (foundTrait != null) {
        char.personality.remove(foundTrait);
        return;
      }
    }
    var searching = true;
    while(searching) {
      var trait = Random.fromArray(Constants.PERSONALITY_TRAITS);
      if (char.personality.indexOf(trait) == -1) {
        char.personality.push(trait);
        searching = false;
      }
    }
  }

}
