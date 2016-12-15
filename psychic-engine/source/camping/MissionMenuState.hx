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

import camping.missionMenu.*;

import gameData.UserData;

class MissionMenuState extends FlxState {

  private var _playBtn:FlxButton;

  public var goldDiv:GoldDiv;

  public var spritesHolder:Array<OneOfTwo<ZoneHub, HeroDragButton>>;

  override public function create():Void {
    super.create();
    var bg = new FlxSprite(0, 0, "assets/images/menu/missionBG.png");
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    FlxG.plugins.add(new FlxMouseControl());

    spritesHolder = new Array<OneOfTwo<ZoneHub, HeroDragButton>>();

    searchForNewHeroes();
    printZones();
    printChars();
    printMoney();
    printButtons();
  }

  public function searchForNewHeroes() {
    UserData.loadUserData();
    for (treasure in UserData.treasures) {
      if (treasure.effectType == TreasureEffect.recruitment) {
        treasure.useTreasure();
      }
    }
  }

  public function calcUsedGold() {
    var goldUsage = UserData.heroes.length * 2;
    for (hero in UserData.heroes) {
      if (hero.goalTile != null || hero.goalChar != null) {
        goldUsage += 3;
      }
    }

    UserData.goldGoal = (UserData.heroes.length + 1) * 5;

    return UserData.goldTotal - goldUsage;
  }

  private function clickPlay():Void {
    if (calcUsedGold() >= 0) {
      UserData.goldTotal = calcUsedGold();
      FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
        FlxG.switchState(new MissionState());
      });
    }
  }

  private function printButtons() {
    _playBtn = new FlxButton(FlxG.width/2 + 185, 25, '', clickPlay);
    _playBtn.loadGraphic("assets/images/menu/playBtn.png", true, 33, 58);

    add(_playBtn);
  }

  private function printChars() {
    var yy = 180;
    for (char in UserData.heroes) {
      char.resetGoals();
      var sprite = new HeroDiv(110, yy, char, spritesHolder);
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

    zonesMap.x = FlxG.width/2 - zonesMap.width/2 + 150;
    zonesMap.y = FlxG.height/2 - zonesMap.height/2 + 15;
    add(zonesMap);
  }

  private function printMoney() {
    goldDiv = new GoldDiv(115, 125);
    add(goldDiv);
  }

}
