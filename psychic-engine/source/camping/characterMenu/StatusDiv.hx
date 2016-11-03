package camping.characterMenu;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

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

  public static function newAtackStatus(xx:Int, yy:Int, label:String, hitChance:Map<BodyKind, Float>):StatusDiv {
    var div = new StatusDiv();

    var statusLabel = new FlxText(xx,yy);
    statusLabel.text = label;
    statusLabel.size = 20;
    statusLabel.color = FlxColor.WHITE;

    var i = 0;
    div.height = statusLabel.height;
    for (body in Type.allEnums(BodyKind)) {
      var image = new FlxSprite(xx + i * 50, yy + statusLabel.height + 10, "assets/images/hud/h" + Std.string(body) + ".png");
      var value = new FlxText(xx + i * 50,yy + statusLabel.height + 20 + image.height);
      value.text = Math.round(hitChance[body] * 100) + "%";
      value.size = 15;
      value.color = FlxColor.WHITE;

      div.add(value);
      div.add(image);
      if (i == 0) {
        div.height += image.height + value.height + 20;
      }
      i++;
    }

    div.add(statusLabel);
    return div;
  }

}
