package camping.reportMenu;

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

class CharReport extends FlxSpriteGroup {

  private var unit:Unit;

  private var heroIcon:FlxSprite;
  private var name:FlxText;
  private var action:FlxText;

  private var goldLbl:FlxText;
  private var treasureLbl:FlxText;
  private var killsLbl:FlxText;

  public function new(xx:Int, yy:Int, unit:Unit) {
    super();
    this.unit = unit;

    heroIcon = new FlxSprite(xx, yy + 2, unit.character.imageSource);
    resizeImage(heroIcon, 40, 40);

    name = new FlxText(xx + 45, yy);
    name.size = 13;
    name.text = unit.character.name;
    name.color = FlxColor.BROWN;

    action = new FlxText(xx + 45, yy + Std.int(name.height/2) + 9);
    action.size = 13;
    action.text = getCharGoalText();
    action.color = FlxColor.GRAY;

    yy += Std.int(heroIcon.height) + 5;

    var gold = new FlxSprite(xx, yy, "assets/images/gold.png");
    resizeImage(gold, 20, 20);
    goldLbl = new FlxText(xx + 25, yy, 20);
    goldLbl.size = 13;
    goldLbl.text = Std.string(unit.goldCollected.length);
    goldLbl.color = FlxColor.GRAY;

    var treasure = new FlxSprite(xx + 50, yy, "assets/images/item.png");
    resizeImage(treasure, 20, 20);
    treasureLbl = new FlxText(xx + 75, yy, 20);
    treasureLbl.size = 13;
    treasureLbl.text = Std.string(unit.treasureCollected.length);
    treasureLbl.color = FlxColor.GRAY;

    var kills = new FlxSprite(xx + 100, yy, "assets/images/hud/skull.png");
    resizeImage(kills, 20, 20);
    killsLbl = new FlxText(xx + 125, yy, 20);
    killsLbl.size = 13;
    killsLbl.text = Std.string(unit.kills);
    killsLbl.color = FlxColor.GRAY;

    add(heroIcon);
    add(name);
    add(action);

    add(gold);
    add(goldLbl);
    add(treasure);
    add(treasureLbl);
    add(kills);
    add(killsLbl);
  }

  private function getCharGoalText():String {
    if (unit.gotBackSafelly) return 'returned successfully';
    return 'died on the mission';
  }

  private function resizeImage(image:FlxSprite, width:Int, height:Int) {
    image.setGraphicSize(width, height);
    image.updateHitbox();
    image.centerOrigin();
  }

}
