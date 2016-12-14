package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

import gameData.Character;

import camping.characterMenu.TraitDiv;

import utils.Constants;

class PersonalityDiv extends FlxSpriteGroup {

  public function new(xx:Int, yy:Int, char:Character) {
    super(xx, yy);

    xx = 30;
    yy = 50;

    var bg = new FlxSprite(0, 0, "assets/images/hud/scroll.png");
    bg.setGraphicSize(268, FlxG.height - 20);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var badge = new FlxSprite(268 - 115, -15, "assets/images/menu/behaviour.png");
    add(badge);

    var traitTxt = new FlxText(xx, yy);
    traitTxt.size = 20;
    traitTxt.text = "TRAITS";
    traitTxt.color = FlxColor.BLACK;
    add(traitTxt);

    yy += Std.int(traitTxt.height) + 8;

    for (trait in char.personality) {
      var label = new TraitDiv(xx, yy, trait);
      add(label);
      yy += 20;
    }

  }

}
