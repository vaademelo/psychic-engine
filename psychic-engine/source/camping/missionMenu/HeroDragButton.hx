package camping.missionMenu;

import flixel.util.typeLimit.OneOfTwo;
import flixel.addons.display.FlxExtendedSprite;

import camping.missionMenu.ZoneHub;

import gameData.Character;
import utils.Constants;

class HeroDragButton extends FlxExtendedSprite {

  public var character:Character;

  public function new(xx:Int, yy:Int, char:Character, spritesHolder:Array<OneOfTwo<ZoneHub, HeroDragButton>>) {
    super(xx, yy, char.imageSource);
    this.character = char;
    this.enableMouseDrag(true);
    this.mouseStopDragCallback = function (obj:FlxExtendedSprite, x:Int, y:Int) {
      for(sprite in spritesHolder) {
        if (obj.overlaps(sprite)) {
          if (Type.getClass(sprite) == ZoneHub) {
            var zone = cast(sprite, ZoneHub);
            obj.x = zone.x + zone.width - obj.width - 10;
            obj.y = zone.y + 10;
            var goalX = Math.floor((zone.info[ZoneInfo.coordX] + 0.5) * Constants.ZONE_SIZE);
            var goalY = Math.floor((zone.info[ZoneInfo.coordY] + 0.5) * Constants.ZONE_SIZE);
            this.character.goalTile = [goalY, goalX];
            return;
          } else if (Type.getClass(sprite) == HeroDragButton) {
            var char = cast(sprite, HeroDragButton);
            this.character.goalUnit = char.character;
          }
        }
      }
      obj.x = xx;
      obj.y = yy;
    }
  }
}
