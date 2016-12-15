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
import camping.GameOverState;

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

    loadMenuData();
    printZones();
    printChars();
    printMoney();
    printButtons();
  }

  public function loadMenuData() {
    UserData.loadUserData();
    for (treasure in UserData.treasures) {
      if (treasure.effectType == TreasureEffect.recruitment) {
        if (UserData.heroes.length >= 4) {
          treasure.convertKind();
        } else {
          treasure.useTreasure();
        }
      }
    }
    if (UserData.goldTotal < 0 || UserData.heroes.length == 0) {
      FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
        FlxG.switchState(new GameOverState());
      });
    }
    UserData.numberOfMissions ++;
    var missions = new FlxText(FlxG.width - 220, 30, 200);
    missions.size = 10;
    missions.alignment = FlxTextAlign.RIGHT;
    if (UserData.numberOfMissions == 1) {
      missions.text = 'first mission';
    } else {
      missions.text = Std.string(UserData.numberOfMissions) + ' consecutive missions';
    }
    missions.color = FlxColor.BLACK;
    add(missions);
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
    var hasAtLeastOneUnitGoing = false;
    for (hero in UserData.heroes) {
      if (hero.goalTile != null || hero.goalChar != null) {
        hasAtLeastOneUnitGoing = true;
        break;
      }
    }
    if (!hasAtLeastOneUnitGoing) return;
    UserData.goldTotal = calcUsedGold();
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new MissionState());
    });
  }

  private function printButtons() {
    _playBtn = new FlxButton(FlxG.width - 95, FlxG.height - 99, '', clickPlay);
    _playBtn.loadGraphic("assets/images/menu/botao.png", true, 75, 79);

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
