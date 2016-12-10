package mission.ui;

import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

import mission.world.Unit;
import mission.world.WorldMap;
import utils.Constants;

class DebugMenu extends FlxSpriteGroup {

  private var button:FlxSprite;

  private var worldMap:WorldMap;

  private var options:FlxSpriteGroup;

  public function new(worldMap:WorldMap, units:Array<Unit>, xx:Float, yy:Float) {
    super(xx, yy);
    this.worldMap = worldMap;

    var bg = new FlxSprite();
    bg.makeGraphic(100, 26, FlxColor.WHITE);

    var label = new FlxText(3, 5);
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

    options = new FlxSpriteGroup(0, 30);
    var optionsBG = new FlxSprite();
    options.add(optionsBG);

    var yy = 3;

    for (unit in units) {
      createUnitMenu(unit, yy);
      yy += 23;
    }

    optionsBG.makeGraphic(100, yy, FlxColor.WHITE);
    options.visible = Constants.debugAi;

    add(bg);
    add(label);
    add(button);
    add(options);
  }

  function createUnitMenu(unit:Unit, yy:Int) {
    var heroIcon = new FlxSprite(3, yy, unit.character.imageSource);
    resizeImage(heroIcon, 20, 20);

    var name = new FlxText(25, yy + 3);
    name.size = 8;
    name.text = unit.character.name;
    name.color = FlxColor.GRAY;

    var btn = new FlxSprite(73, yy);
    btn.loadGraphic("assets/images/hud/onButton.png", true, 24, 20);
    btn.animation.add("on", [0]);
    btn.animation.add("onHover", [1]);
    btn.animation.add("off", [2]);
    btn.animation.add("offHover", [3]);
    function updateBtnState(hover:Bool) {
      var state = (unit.mind.debugMe) ? "on" : "off";
      if (hover) state += "Hover";
      btn.animation.play(state);
    }
    function btnOnMouseUp(sprite:FlxSprite) {
      unit.mind.debugMe = !unit.mind.debugMe;
      updateBtnState(true);
    }
    function btnOnMouseOver(sprite:FlxSprite) {
      updateBtnState(true);
    }
    function btnOnMouseOut(sprite:FlxSprite) {
      updateBtnState(false);
    }
    FlxMouseEventManager.add(btn, null, btnOnMouseUp, btnOnMouseOver, btnOnMouseOut);
    updateState(false);

    options.add(heroIcon);
    options.add(name);
    options.add(btn);
  }

  function buttonOnMouseOver(sprite:FlxSprite) {
    updateState(true);
  }
  function buttonOnMouseOut(sprite:FlxSprite) {
    updateState(false);
  }
  function buttonOnMouseUp(sprite:FlxSprite) {
    Constants.debugAi = !Constants.debugAi;
    if (!Constants.debugAi) worldMap.hud.updateHud(worldMap, worldMap.heroes.members);
    updateState(true);
    options.visible = Constants.debugAi;
  }

  public function updateState(hover:Bool) {
    var state = (Constants.debugAi) ? "on" : "off";
    if (hover) state += "Hover";
    button.animation.play(state);
  }

  private function resizeImage(image:FlxSprite, width:Int, height:Int) {
    image.setGraphicSize(width, height);
    image.updateHitbox();
    image.centerOrigin();
  }

}
