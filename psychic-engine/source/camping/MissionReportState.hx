package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

import utils.Constants;
import utils.MapMaker;

import camping.MissionMenuState;
import camping.reportMenu.CharReport;

import gameData.UserData;

import mission.world.Unit;

class MissionReportState extends FlxState {

  private var _continueBtn:FlxButton;
  private var units:Array<Unit>;

  public function new(units:Array<Unit>) {
    super();
    this.units = units;
  }

  override public function create():Void {
    super.create();
    var bg = new FlxSprite(0, 0, "assets/images/menu/missionBG.png");
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    _continueBtn = new FlxButton(0, 0, "Continue", clickContinue);
    _continueBtn.loadGraphic("assets/images/menu/button.png", true, 261, 46);
    _continueBtn.x = FlxG.width/2 - _continueBtn.width/2;
    _continueBtn.y =  FlxG.height - 30 - _continueBtn.height;
    add(_continueBtn);

    var yPos = 130;
    for (unit in units) {
      var hero = new CharReport(130, yPos, unit);
      add(hero);
      yPos += Std.int(hero.height) + 10;
    }
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  private function clickContinue():Void {
    for (unit in units) {
      if (unit.gotBackSafelly) {
        UserData.goldTotal += unit.goldCollected.length * 5;
        for (treasure in unit.treasureCollected) {
          UserData.treasures.push(treasure.treasure);
        }
      }
    }

    MapMaker.createMap();

    FlxG.switchState(new MissionMenuState());
  }

}
