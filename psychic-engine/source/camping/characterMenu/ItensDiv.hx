package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

import gameData.Character;
import gameData.UserData;
import gameData.Treasure;

import utils.Constants;

import camping.characterMenu.ItemDiv;

class ItensDiv extends FlxSpriteGroup {

  public function new(xx:Int, yy:Int, char:Character, treasureEffect:TreasureEffect, holder:FlxSpriteGroup) {
    super(xx, yy);

    xx = 0;
    yy = 0;

    var titleTxt = new FlxText(xx, yy);
    titleTxt.size = 20;
    titleTxt.text = "ITENS";
    titleTxt.color = FlxColor.BLACK;
    add(titleTxt);
    yy += Std.int(titleTxt.height) + 8;

    for (treasure in UserData.treasures) {
      if (treasure.effectType != treasureEffect) continue;

      var item = new ItemDiv(xx, yy, char, treasure, holder);
      add(item);
      yy += Std.int(item.height) + 4;
    }
  }

}
