package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

import gameData.Character;

import utils.Constants;

class TraitDiv extends FlxSpriteGroup {

  private var tooltip:FlxSpriteGroup;

  public function new(xx:Int, yy:Int, trait:PersonalityTrait) {
    super(xx, yy);

    FlxMouseEventManager.add(this, null, null, onMouseOver, onMouseOut);

    var label = new FlxText();
    label.size = 12;
    label.text = trait.name;
    label.color = FlxColor.BROWN;

    var hoverArea = new FlxSprite();
    hoverArea.makeGraphic(Std.int(label.width), Std.int(label.height), 0x01000000);

    add(hoverArea);
    add(label);

    createTooltip(trait);
  }

  function createTooltip(trait:PersonalityTrait) {
    tooltip = new FlxSpriteGroup(0, -20);
    var bg = new FlxSprite();
    tooltip.add(bg);
    tooltip.visible = false;

    var emotionWeights = new Map<Emotion, Int>();
    for (emotion in Type.allEnums(Emotion)) {
      emotionWeights[emotion] = 0;
    }
    for (effect in trait.effects) {
      emotionWeights[effect.trueEffect] ++;
      emotionWeights[effect.falseEffect] ++;
    }
    var xx = 5;
    var yy = 0;
    for (emotion in Type.allEnums(Emotion)) {
      if (emotionWeights[emotion] == 0 || emotion == Emotion.peaceful) continue;
      var image = new FlxSprite(xx, 5, "assets/images/emotion/" + Std.string(emotion) + ".png");
      resizeImage(image, 20, 20);
      tooltip.add(image);
      var bar = new FlxSprite(xx + 2, 30);
      var size = emotionWeights[emotion] * 5;
      bar.makeGraphic(15, size, FlxColor.BLACK);
      tooltip.add(bar);
      xx += 25;
      if (size > yy) {
        yy = size;
      }
    }

    bg.makeGraphic(xx, yy + 35);
    tooltip.x = -xx - 10;

    add(tooltip);
  }

  function onMouseOver(sprite:FlxSprite) {
    tooltip.visible = true;
  }
  function onMouseOut(sprite:FlxSprite) {
    tooltip.visible = false;
  }

  private function resizeImage(image:FlxSprite, width:Int, height:Int) {
    image.setGraphicSize(width, height);
    image.updateHitbox();
    image.centerOrigin();
  }

}
