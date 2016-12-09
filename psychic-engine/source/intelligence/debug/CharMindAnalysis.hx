package intelligence.debug;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.FlxCamera;
import flixel.input.mouse.FlxMouseEventManager;

import gameData.Character;

import mission.world.WorldMap;

import intelligence.HeroMind;
import intelligence.tools.PositionTool;
import intelligence.debug.EmotionAnalysis;

import utils.Constants;

class CharMindAnalysis extends FlxSpriteGroup {

  public function new(xx:Int, yy:Int, mind:HeroMind) {
    super(xx, yy);

    yy = 0;
    for (emotion in Type.allEnums(Emotion)) {
      if (emotion == Emotion.peaceful) continue;
      var emotionAnalysis = new EmotionAnalysis(yy, mind, emotion);
      add(emotionAnalysis);
      yy += 30;
    }
  }

}
