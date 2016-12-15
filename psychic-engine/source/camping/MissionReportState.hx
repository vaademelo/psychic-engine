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

    var _continueBtn = new FlxButton(FlxG.width - 95, FlxG.height - 99, '', clickContinue);
    _continueBtn.loadGraphic("assets/images/menu/botao.png", true, 75, 79);

    add(_continueBtn);

    var yPos = 130;
    for (unit in units) {
      var hero = new CharReport(130, yPos, unit);
      add(hero);
      yPos += Std.int(hero.height) + 10;
    }

    FlxG.sound.playMusic("assets/sounds/menu_track.ogg");
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  private function clickContinue():Void {
    for (unit in units) {
      if (unit.gotBackSafelly) {
        UserData.goldTotal += unit.goldCollected.length * 2;
        for (treasure in unit.treasureCollected) {
          UserData.treasures.push(treasure.treasure);
        }
      } else {
        UserData.heroes.remove(unit.character);
      }
    }

    MapMaker.createMap();

    FlxG.switchState(new MissionMenuState());
  }

}
