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

  public var friends:Map<Character, FlxSpriteGroup>;

  public function new(xx:Int, yy:Int, char:Character) {
    super(xx, yy);
    updateHolder(char);
  }

  public function updateHolder(char:Character) {
    var xx = 30;
    var yy = 50;

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

    friends = new Map<Character, FlxSpriteGroup>();
    for (friend in char.relationList.keys()) {
      var friendDiv = new FlxSpriteGroup(xx, yy);
      var image = new FlxSprite(0, 0, friend.imageSource);
      var name = new FlxText(image.width + 5, 5);
      name.size = 15;
      name.text = friend.name;
      name.color = FlxColor.BROWN;

      friendDiv.add(image);
      friendDiv.add(name);
      for(i in 1...6) {
        var friendship = new FlxSprite(image.width + ((i - 1) * 22) + 5, name.height + 10, "assets/images/relation/"+i+".png");
        if (i > char.relationList[friend]) {
          friendship.color = FlxColor.BLACK;
        }
        friendDiv.add(friendship);
      }
      add(friendDiv);
      friends[friend] = friendDiv;
      yy += Std.int(image.height) + 8;
    }

    var itensDiv = new ItensDiv(xx, yy, char, TreasureEffect.relation, this);
    add(itensDiv);

  }

}
