package camping.characterMenu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

import gameData.Character;

import camping.characterMenu.StatusDiv;
import camping.characterMenu.ItensDiv;

import utils.Constants;


class CharStatus extends FlxSpriteGroup {

  public var hpLbl:StatusDiv;
  public var injuryLbl:StatusDiv;
  public var moveLbl:StatusDiv;
  public var atackRangeLbl:StatusDiv;
  public var visionLbl:StatusDiv;
  public var bodyLbl:StatusDiv;

  public var hitLbl:StatusDiv;
  public var critLbl:StatusDiv;

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

    var badge = new FlxSprite(268 - 115, -15, "assets/images/menu/attributes.png");
    add(badge);

    var statsTxt = new FlxText(xx, yy);
    statsTxt.size = 20;
    statsTxt.text = "STATS";
    statsTxt.color = FlxColor.BLACK;
    add(statsTxt);
    yy += Std.int(statsTxt.height) + 8;

    var lifeTxt = new FlxText(xx, yy);
    lifeTxt.size = 12;
    lifeTxt.text = "Life:";
    lifeTxt.color = FlxColor.BROWN;
    add(lifeTxt);
    var hearts = new FlxSpriteGroup(xx + lifeTxt.width + 5, yy);
    var nHearts:Int = char.hpMax;
    var xxx = 0;
    for (i in 0 ... nHearts) {
      var heart:FlxSprite = new FlxSprite(xxx, 0);
      heart.loadGraphic("assets/images/hud/heart.png", true, 18, 18);
      heart.animation.add("full", [0]);
      heart.animation.add("empty", [1]);
      heart.animation.play("full");
      heart.animation.stop();
      hearts.add(heart);
      xxx += 18;
    }
    add(hearts);
    yy += Std.int(lifeTxt.height) + 4;

    var staminaTxt = new FlxText(xx, yy);
    staminaTxt.size = 12;
    staminaTxt.text = "Stamina:";
    staminaTxt.color = FlxColor.BROWN;
    add(staminaTxt);
    var injuries = new FlxSpriteGroup(xx + staminaTxt.width + 5, yy);
    var nInjuries:Int = char.injuryMax;
    xxx = 0;
    for (i in 0 ... nInjuries) {
      var injury:FlxSprite = new FlxSprite(xxx, 0);
      injury.loadGraphic("assets/images/hud/injury.png", true, 18, 18);
      injury.animation.add("full", [0]);
      injury.animation.add("empty", [1]);
      injury.animation.play("full");
      injury.animation.stop();
      injuries.add(injury);
      xxx += 18;
    }
    add(injuries);
    yy += Std.int(staminaTxt.height) + 4;

    var xxx = addIconStatus(moveLbl, xx, yy, "Movement", char.movement);
    xxx = addIconStatus(visionLbl, xxx, yy, "Vision", char.vision);
    yy = addBodyKind(bodyLbl, xxx, yy, char.bodyKind);

    yy = addAtackStats(hitLbl, xx, yy, "Hit Chance", char.hitChance);
    yy = addAtackStats(critLbl, xx, yy, "Crit Chance", char.critChance);

    var itensDiv = new ItensDiv(xx, yy, char, TreasureEffect.training, this);
    add(itensDiv);
  }

  public function addBodyKind(div:StatusDiv, xx:Int, yy:Int, kind:BodyKind):Int {
    div = StatusDiv.newBodyTypeStatus(xx, yy, kind);
    yy += Std.int(div.height) + 4;
    add(div);
    return yy;
  }

  public function addAtackStats(div:StatusDiv, xx:Int, yy:Int, label:String, hitChance:Map<BodyKind, Float>):Int {
    div = StatusDiv.newAtackStatus(xx, yy, label, hitChance);
    yy += Std.int(div.height) + 4;
    add(div);
    return yy;
  }

  public function addIconStatus(div:StatusDiv, xx:Int, yy:Int, label:String, value:Int) {
    div = StatusDiv.newNumberWithIconStatus(xx, yy, label, value);
    xx += 45;
    add(div);
    return xx;
  }

}
