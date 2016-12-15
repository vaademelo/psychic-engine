package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxExtendedSprite;

import gameData.Character;
import gameData.UserData;
import gameData.Treasure;

import utils.Constants;

import camping.characterMenu.CharStatus;
import camping.characterMenu.FriendsDiv;
import camping.characterMenu.PersonalityDiv;

class ItemDiv extends FlxSpriteGroup {

  private var char:Character;
  private var secondChar:Character;
  private var treasure:Treasure;
  private var holder:FlxSprite;

  public function new(xx:Int, yy:Int, char:Character, treasure:Treasure, holder:FlxSpriteGroup) {
    super(xx, yy);
    this.char = char;
    this.treasure = treasure;
    this.holder = holder;

    xx = 0;
    yy = 0;

    var treasureLabel = new FlxText(xx, yy);
    treasureLabel.size = 12;
    treasureLabel.text = treasure.effectDetail;
    treasureLabel.color = FlxColor.BLACK;
    add(treasureLabel);

    if (treasure.effectType == TreasureEffect.relation) {
      var drop = new FlxExtendedSprite(xx + Std.int(treasureLabel.width) + 5, yy, "assets/images/menu/dragBtn.png");
      drop.enableMouseDrag(true);
      var friends = cast(holder, FriendsDiv).friends;
      drop.mouseStopDragCallback = function (obj:FlxExtendedSprite, x:Int, y:Int):Bool {
        for (friend in friends.keys()) {
          if (obj.overlaps(friends[friend])) {
            secondChar = friend;
            return useTreasure();
          }
        }
        return true;
      }
      add(drop);
    } else {
      var useButton = new FlxButton(xx + Std.int(treasureLabel.width) + 5, yy, 'Use', useTreasure);
      add(useButton);
    }
  }

  public function useTreasure():Bool {
    treasure.useTreasure(this.char, this.secondChar);
    switch treasure.effectType {
      case TreasureEffect.recruitment:
        trace("This should never happen");
      case TreasureEffect.training:
        cast(holder, CharStatus).updateHolder(this.char);
      case TreasureEffect.behaviour:
        cast(holder, PersonalityDiv).updateHolder(this.char);
      case TreasureEffect.relation:
        cast(holder, FriendsDiv).updateHolder(this.char);
    }
    return true;
  }

}
