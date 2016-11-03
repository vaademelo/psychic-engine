package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import gameData.Character;

import utils.Constants;

class FriendsDiv extends FlxGroup {

  public function new(xx:Int, yy:Int, char:Character) {
    super();

    for (friend in char.relationList.keys()) {
      var image = new FlxSprite(xx, yy, friend.imageSource);
      var name = new FlxText(xx + image.width + 5, yy);
      name.size = 20;
      name.text = friend.name;
      name.color = FlxColor.WHITE;

      for(i in 1...6) {
        var friendship = new FlxSprite(xx + ((i - 1) * 30), yy + image.height + 5, "assets/images/relation/"+i+".png");
        if (i > char.relationList[friend]) {
          friendship.color = FlxColor.BLACK;
        }
        friendship.setGraphicSize(25, 25);
        friendship.updateHitbox();
        friendship.centerOrigin();
        add(friendship);
      }
      add(image);
      add(name);
      yy += Std.int(image.height) + 40;
    }
    //var image = new FlxSprite(xx, yy, "assets/images/emotion/" + )

  }

}
