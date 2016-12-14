package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

import gameData.Character;

import utils.Constants;

class StatusDiv extends FlxSpriteGroup {

  public static function newBodyTypeStatus(xx:Int, yy:Int, bodyKind:BodyKind):StatusDiv {
    var div = new StatusDiv();

    var statusLabel = new FlxText(xx,yy + 3);
    statusLabel.text = "Body:";
    statusLabel.size = 12;
    statusLabel.color = FlxColor.BROWN;

    var image = new FlxSprite(xx + Std.int(statusLabel.width) + 2, yy, "assets/images/menu/" + Std.string(bodyKind) + ".png");
    resizeImage(image, 0, 25);

    div.add(statusLabel);
    div.add(image);
    return div;
  }

  public static function newAtackStatus(xx:Int, yy:Int, label:String, hitChance:Map<BodyKind, Float>):StatusDiv {
    var div = new StatusDiv();

    var statusLabel = new FlxText(xx,yy);
    statusLabel.text = label;
    statusLabel.size = 12;
    statusLabel.color = FlxColor.BROWN;

    yy += Std.int(statusLabel.height) + 4;
    for (body in Type.allEnums(BodyKind)) {
      var image = new FlxSprite(xx, yy, "assets/images/menu/" + Std.string(body) + ".png");
      resizeImage(image, 0, 25);
      xx += Std.int(image.width) + 3;

      var value = new FlxText(xx, yy + 3);
      value.text = Math.round(hitChance[body] * 100) + "%";
      value.size = 12;
      value.color = FlxColor.BROWN;
      xx += Std.int(value.width) + 5;

      div.add(value);
      div.add(image);
    }

    div.add(statusLabel);
    return div;
  }

  public static function newNumberWithIconStatus(xx:Int, yy:Int, status:String, value:Int):StatusDiv {
    var div = new StatusDiv();

    var image = new FlxSprite(xx, yy, "assets/images/menu/" + status + ".png");

    var statusLabel = new FlxText(xx + image.height + 5, yy + 2);
    statusLabel.text = Std.string(value);
    statusLabel.size = 12;
    statusLabel.color = FlxColor.BROWN;

    div.add(image);
    div.add(statusLabel);
    div.height = statusLabel.height;

    var tooltip = new FlxSpriteGroup(xx - 10, yy - 28);
    var bg = new FlxSprite();

    var label = new FlxText(4,4);
    label.text = status;
    label.size = 12;
    label.color = FlxColor.BLACK;
    bg.makeGraphic(Std.int(label.width) + 8, 24);
    div.add(tooltip);
    tooltip.add(bg);
    tooltip.add(label);
    tooltip.visible = false;

    function onMouseOver(sprite:FlxSprite) {
      tooltip.visible = true;
    }
    function onMouseOut(sprite:FlxSprite) {
      tooltip.visible = false;
    }
    FlxMouseEventManager.add(div, null, null, onMouseOver, onMouseOut);

    return div;
  }

  private static function resizeImage(image:FlxSprite, width:Int, height:Int) {
    image.setGraphicSize(width, height);
    image.updateHitbox();
    image.centerOrigin();
  }

}
