package camping.characterMenu;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import gameData.Character;

import camping.characterMenu.StatusDiv;

import utils.Constants;

class CharStatus extends FlxGroup {

  public var hpLbl:StatusDiv;
  public var injuryLbl:StatusDiv;
  public var moveLbl:StatusDiv;
  public var atackRangeLbl:StatusDiv;
  public var visionLbl:StatusDiv;

  public function new(xx:Int, yy:Int, char:Character) {
    super();

    yy = addStatus(hpLbl, xx, yy, "Life", char.hpMax, Constants.MAX_LIFE);
    yy = addStatus(injuryLbl, xx, yy, "Stamina", char.injuryMax, Constants.MAX_INJURY);
    yy = addStatus(moveLbl, xx, yy, "Movement", char.movement, Constants.MAX_MOVEMENT);
    yy = addStatus(atackRangeLbl, xx, yy, "Atack Range", char.atackRange, Constants.MAX_ATACKRANGE);
    yy = addStatus(visionLbl, xx, yy, "Vision", char.vision, Constants.MAX_VISION);
  }

  public function addStatus(div:StatusDiv, xx:Int, yy:Int, label:String, value:Int, maxValue:Int):Int {
    div = StatusDiv.newNumberStatus(xx, yy, label, value, maxValue);
    yy += Std.int(div.height) + 5;
    add(div);
    return yy;
  }

}
