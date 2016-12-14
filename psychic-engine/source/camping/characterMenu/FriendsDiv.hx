package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

import gameData.Character;

import utils.Constants;

class FriendsDiv extends FlxSpriteGroup {

  public function new(xx:Int, yy:Int, char:Character) {
    super(xx, yy);

    xx = 30;
    yy = 50;

    var bg = new FlxSprite(0, 0, "assets/images/hud/scroll.png");
    bg.setGraphicSize(268, FlxG.height - 20);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var badge = new FlxSprite(268 - 115, -15, "assets/images/menu/relation.png");
    add(badge);

    var friendsTxt = new FlxText(xx, yy);
    friendsTxt.size = 20;
    friendsTxt.text = "AFFINITY";
    friendsTxt.color = FlxColor.BLACK;
    add(friendsTxt);

    yy += Std.int(friendsTxt.height) + 8;

    for (friend in char.relationList.keys()) {
      var image = new FlxSprite(xx, yy, friend.imageSource);
      var name = new FlxText(xx + image.width + 5, yy + 5);
      name.size = 15;
      name.text = friend.name;
      name.color = FlxColor.BROWN;

      for(i in 1...6) {
        var friendship = new FlxSprite(xx + image.width + ((i - 1) * 22) + 5, yy + name.height + 10, "assets/images/relation/"+i+".png");
        if (i > char.relationList[friend]) {
          friendship.color = FlxColor.BLACK;
        }
        add(friendship);
      }
      add(image);
      add(name);
      yy += Std.int(image.height) + 8;
    }

  }

}
