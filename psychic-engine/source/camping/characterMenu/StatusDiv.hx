package camping.characterMenu;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

import gameData.Character;

import utils.Constants;

class StatusDiv extends FlxGroup {

  public var height:Float = 0;

  public static function newNumberStatus(xx:Int, yy:Int, status:String, value:Int, maxValue:Int):StatusDiv {
    var div = new StatusDiv();

    var statusLabel = new FlxText(xx,yy);
    statusLabel.text = status + ": " + value + "/" + maxValue;
    statusLabel.size = 20;
    statusLabel.color = FlxColor.WHITE;

    div.add(statusLabel);
    div.height = statusLabel.height;
    return div;
  }

  public static function newBodyTypeStatus(xx:Int, yy:Int, bodyKind:BodyKind):StatusDiv {
    var div = new StatusDiv();

    var statusLabel = new FlxText(xx,yy);
    statusLabel.text = "Body Type: " + Std.string(bodyKind);
    statusLabel.size = 20;
    statusLabel.color = FlxColor.WHITE;

    div.add(statusLabel);
    div.height = statusLabel.height;
    return div;
  }

}
