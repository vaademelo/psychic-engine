package mission.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

import gameData.Character;

import mission.world.Unit;
import mission.world.WorldMap;

import intelligence.tools.PositionTool;

class CharHud extends FlxSpriteGroup {

  private var unit:Unit;
  private var worldMap:WorldMap;

  private var heroIcon:FlxSprite;
  private var name:FlxText;
  private var action:FlxText;
  private var hearts:FlxSpriteGroup;
  private var injuries:FlxSpriteGroup;

  public function new(xx:Int, yy:Int, unit:Unit, worldMap:WorldMap) {
    super();
    this.unit = unit;
    this.worldMap = worldMap;

    heroIcon = new FlxSprite(xx, yy, unit.character.imageSource);
    heroIcon.setGraphicSize(30, 30);
    heroIcon.updateHitbox();
    heroIcon.centerOrigin();

    name = new FlxText(xx + 35, yy);
    name.size = 15;
    name.text = unit.character.name;
    name.color = FlxColor.BROWN;

    yy += Std.int(heroIcon.height) + 5;

    action = new FlxText(xx, yy);
    action.size = 15;
    action.text = getCharGoalText();
    action.color = FlxColor.GRAY;

    yy += Std.int(action.height) + 5;

    hearts = new FlxSpriteGroup(xx, yy);
    var nHearts:Int = unit.character.hpMax;
    for (i in 0 ... nHearts) {
      var heart:FlxSprite = new FlxSprite(i * 23, 0);
      heart.loadGraphic("assets/images/hud/heart.png", true, 18, 18);
      heart.animation.add("full", [0]);
      heart.animation.add("empty", [1]);
      heart.animation.play("full");
      heart.animation.stop();
      hearts.add(heart);
    }

    yy += Std.int(hearts.height) + 5;

    injuries = new FlxSpriteGroup(xx, yy);
    var nInjuries:Int = unit.character.injuryMax;
    for (i in 0 ... nInjuries) {
      var injury:FlxSprite = new FlxSprite(i * 23, 0);
      injury.loadGraphic("assets/images/hud/injury.png", true, 28, 18);
      injury.animation.add("full", [0]);
      injury.animation.add("empty", [1]);
      injury.animation.play("empty");
      injury.animation.stop();
      injuries.add(injury);
    }

    add(heroIcon);
    add(name);
    add(action);
    add(hearts);
    add(injuries);

  }

  public function updateCharacterHud() {
    action.text = getCharGoalText();

    var nHearts:Int = unit.character.hpMax;
    for (i in 0 ... nHearts) {
      if(i < unit.hp) {
        hearts.members[i].animation.play("full");
        hearts.members[i].animation.stop();
      } else {
        hearts.members[i].animation.play("empty");
        hearts.members[i].animation.stop();
      }
    }
    var nInjuries:Int = unit.character.injuryMax;
    for (i in 0 ... nInjuries) {
      if(i >= unit.injury) {
        injuries.members[i].animation.play("empty");
        injuries.members[i].animation.stop();
      } else {
        injuries.members[i].animation.play("full");
        injuries.members[i].animation.stop();
      }
    }
  }

  private function getCharGoalText():String {
    if (unit.character.goalChar != null) return "will protect " + unit.character.goalChar.name;
    if (unit.character.goalTile == worldMap.homeTile) return "is going home";
    var currentZone:Array<Int> = PositionTool.getZoneForTile(unit.getCoordinate());
    var desiredZone:Array<Int> = PositionTool.getZoneForTile(unit.character.goalTile);
    if(worldMap.isTheSameTile(currentZone, desiredZone)) {
      return "searching on zone " + worldMap.getZoneName(desiredZone);
    } else {
      return "is going to zone " + worldMap.getZoneName(desiredZone);
    }
  }

}
