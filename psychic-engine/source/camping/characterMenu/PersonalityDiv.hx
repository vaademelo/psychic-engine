package camping.characterMenu;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import gameData.Character;

import utils.Constants;

class PersonalityDiv extends FlxGroup {

  public function new(xx:Int, yy:Int, char:Character) {
    super();

    for (trait in char.personality) {
      var label = new FlxText(xx, yy);
      label.size = 20;
      label.text = trait.name;
      label.color = FlxColor.WHITE;
      add(label);
      yy += Std.int(label.height) + 10;
    }
    //var image = new FlxSprite(xx, yy, "assets/images/emotion/" + )

  }

}
