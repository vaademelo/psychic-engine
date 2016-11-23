package camping.characterMenu;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import gameData.Character;

import camping.characterMenu.TraitDiv;

import utils.Constants;

class PersonalityDiv extends FlxGroup {

  public function new(xx:Int, yy:Int, char:Character) {
    super();

    for (trait in char.personality) {
      var label = new TraitDiv(xx, yy, trait);
      add(label);
      yy += 30;
    }

  }

}
