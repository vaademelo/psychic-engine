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

import utils.Constants;

class EmotionAnalysis extends FlxSpriteGroup {

  private var triggersEffectHud:FlxSpriteGroup;

  public function new(yy:Int, mind:HeroMind, emotion:Emotion) {
    super(0, yy);

    var emotionIcon = new FlxSprite(0, 0, "assets/images/emotion/" + Std.string(emotion) + ".png");
    resizeImage(emotionIcon, 20, 20);

    var lastTurn = new FlxText(30, 0, 30);
    lastTurn.size = 13;
    lastTurn.text = Std.string(mind.emotionsLastTurn[emotion]);
    lastTurn.alignment = FlxTextAlign.CENTER;
    lastTurn.color = FlxColor.BROWN;

    var amotizationText = new FlxText(70, 0, 30);
    amotizationText.size = 13;
    amotizationText.text = Std.string(mind.emotionsAmortization[emotion]);
    amotizationText.alignment = FlxTextAlign.CENTER;
    amotizationText.color = FlxColor.RED;

    var triggersValue = mind.emotionWeights[emotion] - (mind.emotionsLastTurn[emotion] - mind.emotionsAmortization[emotion]);
    var triggersEffect = new FlxText(110, 0, 30);
    triggersEffect.size = 13;
    triggersEffect.text = Std.string(triggersValue);
    triggersEffect.alignment = FlxTextAlign.CENTER;
    triggersEffect.color = FlxColor.BROWN;

    var currentTurn = new FlxText(150, 0, 30);
    currentTurn.size = 13;
    currentTurn.text = Std.string(mind.emotionWeights[emotion]);
    currentTurn.alignment = FlxTextAlign.CENTER;
    currentTurn.color = FlxColor.BROWN;

    if (triggersValue > 0) {
      var hoverArea = new FlxSprite(0, 0);
      hoverArea.makeGraphic(180, 20, 0x01000000);
      add(hoverArea);
      createTriggersEffectHud(mind, emotion);
      function mouseOver(sprite:FlxSprite) {
        triggersEffectHud.visible = true;
      }

      function mouseOut(sprite:FlxSprite) {
        triggersEffectHud.visible = false;
      }
      FlxMouseEventManager.add(this, null, null, mouseOver, mouseOut);
    }
    if (emotion == mind.lastEmotion) {
      var bg = new FlxSprite(0, 0);
      bg.makeGraphic(90, 20, 0x50FFFFFF);
      add(bg);
    }
    if (emotion == mind.currentEmotion) {
      var bg = new FlxSprite(90, 0);
      bg.makeGraphic(90, 20, 0x50FFFFFF);
      add(bg);
    }

    add(emotionIcon);
    add(lastTurn);
    add(amotizationText);
    add(triggersEffect);
    add(currentTurn);
  }

  private function createTriggersEffectHud(mind:HeroMind, emotion:Emotion) {
    triggersEffectHud = new FlxSpriteGroup(200, 0);

    var bg = new FlxSprite();
    triggersEffectHud.add(bg);

    var yy = 0;
    var triggers = mind.triggersEffectOnEmotions[emotion];
    for (trigger in triggers.keys()) {
      var labelText = new FlxText(5, yy, 200);
      labelText.size = 10;
      labelText.text = trigger + ':';
      labelText.alignment = FlxTextAlign.RIGHT;
      labelText.color = FlxColor.GRAY;

      var analysisText = new FlxText(210, yy, 30);
      analysisText.size = 10;
      analysisText.text = Std.string(triggers[trigger]);
      analysisText.alignment = FlxTextAlign.CENTER;
      analysisText.color = FlxColor.BLACK;

      triggersEffectHud.add(labelText);
      triggersEffectHud.add(analysisText);

      yy += 15;
    }

    bg.makeGraphic(245, yy, FlxColor.WHITE);
    triggersEffectHud.visible = false;
    add(triggersEffectHud);
  }

  private function resizeImage(image:FlxSprite, width:Int, height:Int) {
    image.setGraphicSize(width, height);
    image.updateHitbox();
    image.centerOrigin();
  }

}
