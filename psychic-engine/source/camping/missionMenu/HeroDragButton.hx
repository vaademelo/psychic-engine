package camping.missionMenu;

import flixel.util.typeLimit.OneOfTwo;
import flixel.addons.display.FlxExtendedSprite;
import flixel.text.FlxText;

import camping.missionMenu.ZoneHub;

import gameData.Character;
import utils.Constants;

class HeroDragButton extends FlxExtendedSprite {

  public var character:Character;

  public function new(xx:Int, yy:Int, char:Character, spritesHolder:Array<OneOfTwo<ZoneHub, HeroDragButton>>, action:FlxText) {
    super(xx, yy, char.imageSource);
    this.setGraphicSize(40, 40);
    this.updateHitbox();
    this.centerOrigin();
    this.character = char;
    this.enableMouseDrag(true);
    this.mouseStopDragCallback = function (obj:FlxExtendedSprite, x:Int, y:Int):Bool {
      for(sprite in spritesHolder) {
        if (obj.overlaps(sprite)) {
          if (Type.getClass(sprite) == ZoneHub) {
            var zone = cast(sprite, ZoneHub);
            obj.x = zone.x + zone.width - obj.width - 10;
            obj.y = zone.y + 10;
            var goalX = Math.floor((zone.info[ZoneInfo.coordX] + 0.5) * Constants.ZONE_SIZE);
            var goalY = Math.floor((zone.info[ZoneInfo.coordY] + 0.5) * Constants.ZONE_SIZE);
            this.character.goalTile = [goalY, goalX];
            this.character.goalUnit = null;
            action.text = "is going to zone " + zone.info[ZoneInfo.name];
            return goBack(xx, yy);
          } else if (Type.getClass(sprite) == HeroDragButton && sprite != obj) {
            var char = cast(sprite, HeroDragButton);
            this.character.goalUnit = char.character;
            this.character.goalTile = null;
            action.text = "will protect " + char.character.name;
            return goBack(xx, yy);
          }
        }
      }
      this.character.goalTile = null;
      this.character.goalUnit = null;
      action.text = "is not going";
      return goBack(xx, yy);
    }
  }

  private function goBack(xx:Int, yy:Int):Bool {
    this.x = xx;
    this.y = yy;
    return true;
  }
}
