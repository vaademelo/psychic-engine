package camping.missionMenu;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.util.typeLimit.OneOfTwo;
import utils.MapMaker;

import utils.Constants;

class ZoneHub extends FlxSpriteGroup {

  public var info:Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>;

  public function new(zone:Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>) {
    super();
    this.info = zone;
    var zoneBG = new FlxSprite();
    zoneBG.loadGraphic("assets/images/menu/zone.png");
    this.add(zoneBG);

    var minZoneXCoordinate = MapMaker.minZoneXCoordinate();
    var minZoneYCoordinate = MapMaker.minZoneYCoordinate();

    var nKeys = 0;
    for(key in zone.keys()) {
      var icon:FlxSprite = new FlxSprite();
      var text:FlxText = null;
      switch (key) {
        case ZoneInfo.kind:
          if(cast(zone[key], ZoneKind) != ZoneKind.starter) continue;
          icon.x = 6;
          icon.y = 6;
          icon.loadGraphic('assets/images/menu/zones/home.png');
        case ZoneInfo.nMonsters:
          if(cast(zone[key], Int) < 4) continue;
          icon.loadGraphic('assets/images/menu/zones/monster.png');
          icon.x = 15;
          icon.y = zoneBG.height - 15 - icon.height;
        case ZoneInfo.ngold:
          if(cast(zone[key], Int) < 4) continue;
          icon.loadGraphic('assets/images/menu/zones/gold.png');
          icon.x = zoneBG.width - 15 - icon.width;
          icon.y = zoneBG.height - 15 - icon.height;
        case ZoneInfo.nTreasures:
          if(cast(zone[key], Int) < 2) continue;
          icon.loadGraphic('assets/images/menu/zones/item.png');
          icon.x = zoneBG.width/2 - icon.width/2;
          icon.y = zoneBG.height - 30 - icon.height;
        case ZoneInfo.coordX:
          if (minZoneXCoordinate < 0) {
            this.x = (zone[key] + Math.abs(minZoneXCoordinate)) * 100;
          } else {
            this.x = zone[key] * 100;
          }
          continue;
        case ZoneInfo.coordY:
          if (minZoneYCoordinate < 0) {
            this.y = (zone[key] + Math.abs(minZoneYCoordinate)) * 100;
          } else {
            this.y = zone[key] * 100;
          }
          continue;
        case ZoneInfo.name:
          text = new FlxText(zoneBG.width - 30, 10);
          text.text = Std.string(zone[key]);
          text.size = 16;
          text.color = FlxColor.BLACK;
          text.alignment = FlxTextAlign.RIGHT;
          this.add(text);
          continue;
      }
      if (icon != null) this.add(icon);
      if (text != null) this.add(text);
    }
  }
}
