package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.MapMaker;
import utils.Constants;

import mission.MissionState;

import gameData.UserData;

class MissionMenuState extends FlxState {

  private var _playBtn:FlxButton;
  private var _resetBtn:FlxButton;

  override public function create():Void {
    super.create();

    printChars();
    printZones();
    printButtons();
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
      var sprite = new FlxSprite(0, yy, char.imageSource);
      yy += 50;
      add(sprite);
    }
  }

  private function printZones() {
    var zonesMap = new FlxSpriteGroup();

    var xx = 0;
    var zones = MapMaker.getMapZones();
    for (zone in zones) {
      var zoneHub = new FlxSpriteGroup();
      zonesMap.add(zoneHub);

      var posX = xx;
      var posY = 0;

      var zoneBG = new FlxSprite();
      zoneBG.x = posX;
      zoneBG.y = posY;
      zoneBG.makeGraphic(190, 190);
      zoneHub.add(zoneBG);

      var nKeys = 0;
      for(key in zone.keys()) {
        var icon:FlxSprite = new FlxSprite();
        var text:FlxText = null;
        switch (key) {
        case ZoneInfo.kind:
          if(cast(zone[key], ZoneKind) != ZoneKind.starter) continue;
          icon.x = posX + 6;
          icon.y = posY + 6;
          icon.loadGraphic('assets/images/menu/zones/home.png');
        case ZoneInfo.nMonsters:
          icon.loadGraphic('assets/images/menu/zones/monster.png');
        case ZoneInfo.nFood:
          icon.loadGraphic('assets/images/menu/zones/food.png');
        case ZoneInfo.nTreasures:
          icon.loadGraphic('assets/images/menu/zones/item.png');
        }
        if (key != ZoneInfo.kind) {
          icon.x = posX + zoneBG.width - 30;
          icon.y = posY + zoneBG.height - 30 - (nKeys * 30);
          text = new FlxText(posX + zoneBG.width - 60, posY + zoneBG.height - 30 - (nKeys * 30), 25);
          text.setFormat("assets/fonts/SheepingDogs.ttf", 16, FlxColor.BLACK, FlxTextAlign.RIGHT);
          text.text = Std.string(zone[key]);
          nKeys++;
        }
        if (icon != null) zoneHub.add(icon);
        if (text != null) zoneHub.add(text);
      }

      xx += 200;
    }

    zonesMap.x = FlxG.width/2 - 200 * zones.length/2;
    zonesMap.y = FlxG.height/2 - zonesMap.height/2;
    add(zonesMap);
  }

}
