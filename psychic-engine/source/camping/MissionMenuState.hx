package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.util.typeLimit.OneOfTwo;
import flixel.addons.plugin.FlxMouseControl;

import utils.MapMaker;
import utils.Constants;

import mission.MissionState;

import camping.missionMenu.ZoneHub;
import camping.missionMenu.HeroDiv;
import camping.missionMenu.HeroDragButton;

import gameData.UserData;

class MissionMenuState extends FlxState {

  private var _playBtn:FlxButton;
  private var _resetBtn:FlxButton;

  public var spritesHolder:Array<OneOfTwo<ZoneHub, HeroDragButton>>;

  override public function create():Void {
    super.create();

    FlxG.plugins.add(new FlxMouseControl());

    spritesHolder = new Array<OneOfTwo<ZoneHub, HeroDragButton>>();

    UserData.goldGoal = 1;

    printButtons();
    printZones();
    printChars();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  private function clickPlay():Void {
    FlxG.switchState(new MissionState());
  }

  private function clickReset():Void {
    //TODO: reset character goals
  }

  private function printButtons() {
    _playBtn = new FlxButton(0, 0, "Play", clickPlay);
    _resetBtn = new FlxButton(0, 0, "Reset", clickReset);

    _playBtn.x = _resetBtn.x = FlxG.width - 30 - _playBtn.width;
    _playBtn.y = FlxG.height - 30 - _playBtn.height;
    _resetBtn.y = FlxG.height - 60 - _resetBtn.height;

    add(_playBtn);
    add(_resetBtn);
  }

  private function printChars() {
    var yy = 0;
    UserData.loadUserData();
    for (char in UserData.heroes) {
      var sprite = new HeroDiv(0, yy, char, spritesHolder);
      add(sprite);
      yy += 50;
    }
  }

  private function printZones() {
    var zonesMap = new FlxSpriteGroup();

    var zones = MapMaker.getMapZones();
    for (zone in zones) {
      var zoneHub = new ZoneHub(zone);
      zonesMap.add(zoneHub);
      spritesHolder.push(zoneHub);
    }

    zonesMap.x = FlxG.width/2 - 200 * zones.length/2;
    zonesMap.y = FlxG.height/2 - zonesMap.height/2;
    add(zonesMap);
  }

}
