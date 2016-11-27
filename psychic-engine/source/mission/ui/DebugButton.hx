package mission.ui;

import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

import utils.Constants;

class DebugButton extends FlxSpriteGroup {

  private var button:FlxSprite;

  public function new(xx:Float, yy:Float) {
    super(xx, yy);

    var bg = new FlxSprite();
    bg.makeGraphic(100, 26, FlxColor.WHITE);

    var label = new FlxText(3, 3);
    label.size = 10;
    label.text = "Debug AI:";
    label.color = FlxColor.GRAY;

    button = new FlxSprite(73, 3);
    button.loadGraphic("assets/images/hud/onButton.png", true, 24, 20);
    button.animation.add("on", [0]);
    button.animation.add("onHover", [1]);
    button.animation.add("off", [2]);
    button.animation.add("offHover", [3]);
    FlxMouseEventManager.add(button, null, buttonOnMouseUp, buttonOnMouseOver, buttonOnMouseOut);
    updateState(false);

    add(bg);
    add(label);
    add(button);
  }

  function buttonOnMouseOver(sprite:FlxSprite) {
    updateState(true);
  }
  function buttonOnMouseOut(sprite:FlxSprite) {
    updateState(false);
  }
  function buttonOnMouseUp(sprite:FlxSprite) {
    Constants.debugAi = !Constants.debugAi;
    updateState(true);
  }

  public function updateState(hover:Bool) {
    var state = (Constants.debugAi) ? "on" : "off";
    if (hover) state += "Hover";
    button.animation.play(state);
  }

}
