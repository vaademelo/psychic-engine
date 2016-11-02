package camping.missionMenu;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;

class ZoneHub extends FlxSpriteGroup {

  public var info:Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>;

  public function new(zone:Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>) {
    super();
    this.info = zone;
    var zoneBG = new FlxSprite();
    zoneBG.makeGraphic(190, 190);
    this.add(zoneBG);

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
        icon.loadGraphic('assets/images/menu/zones/monster.png');
      case ZoneInfo.nFood:
        icon.loadGraphic('assets/images/menu/zones/food.png');
      case ZoneInfo.nTreasures:
        icon.loadGraphic('assets/images/menu/zones/item.png');
      case ZoneInfo.coordX:
        this.x = zone[key] * 200;
        continue;
      case ZoneInfo.coordY:
        this.y = zone[key] * 200;
        continue;
      case ZoneInfo.name:
        var name = new FlxText(zoneBG.width - 60, 10, 50);
        name.text = "zone " + zone[key];
        name.setFormat("assets/fonts/SheepingDogs.ttf", 16, FlxColor.BLACK, FlxTextAlign.RIGHT);
        this.add(name);
        continue;
      }
      if (key != ZoneInfo.kind) {
        icon.x = zoneBG.width - 30;
        icon.y = zoneBG.height - 30 - (nKeys * 30);
        text = new FlxText(zoneBG.width - 60, zoneBG.height - 30 - (nKeys * 30), 25);
        text.setFormat("assets/fonts/SheepingDogs.ttf", 16, FlxColor.BLACK, FlxTextAlign.RIGHT);
        text.text = Std.string(zone[key]);
        nKeys++;
      }
      if (icon != null) this.add(icon);
      if (text != null) this.add(text);
    }
  }
}
