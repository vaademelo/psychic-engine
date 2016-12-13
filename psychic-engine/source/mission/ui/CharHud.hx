package mission.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.FlxCamera;
import flixel.input.mouse.FlxMouseEventManager;

import gameData.Character;

import mission.world.Unit;
import mission.world.WorldMap;

import intelligence.HeroMind;
import intelligence.tools.PositionTool;
import intelligence.debug.CharMindAnalysis;

class CharHud extends FlxSpriteGroup {

  private var unit:Unit;
  private var worldMap:WorldMap;

  private var heroIcon:FlxSprite;
  private var emotionIcon:FlxSprite;
  private var name:FlxText;
  private var action:FlxText;
  private var follow:FlxButton;
  private var hearts:FlxSpriteGroup;
  private var injuries:FlxSpriteGroup;

  private var hurtMarker:FlxSpriteGroup;
  private var hurtToggle:FlxSpriteGroup;
  private var hurtImage:FlxSprite;

  private var goldLbl:FlxText;
  private var treasureLbl:FlxText;
  private var killsLbl:FlxText;

  public var continueBtn:FlxButton;
  public var CharMindAnalysis:CharMindAnalysis;

  public function new(xx:Int, yy:Int, unit:Unit, worldMap:WorldMap, debug:Bool = false) {
    super();
    this.unit = unit;
    this.worldMap = worldMap;

    heroIcon = new FlxSprite(xx, yy + 2, unit.character.imageSource);
    resizeImage(heroIcon, 40, 40);

    emotionIcon = new FlxSprite(xx + 45, yy, "assets/images/emotion/" + Std.string(unit.mind.currentEmotion) + ".png");
    resizeImage(emotionIcon, 20, 20);

    name = new FlxText(xx + 70, yy);
    name.size = 13;
    name.text = unit.character.name;
    name.color = FlxColor.BROWN;

    action = new FlxText(xx + 45, yy + Std.int(name.height/2) + 9);
    action.size = 13;
    action.text = getCharGoalText();
    action.color = FlxColor.GRAY;

    yy += Std.int(heroIcon.height) + 5;
    var xxx = 0;

    hearts = new FlxSpriteGroup(xx, yy);
    var nHearts:Int = unit.character.hpMax;
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

    xxx += 5;
    injuries = new FlxSpriteGroup(xx, yy);
    var nInjuries:Int = unit.character.injuryMax;
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

    hurtMarker = new FlxSpriteGroup(xx + xxx + 5, yy);
    hurtImage = new FlxSprite(0, -1, "assets/images/hud/hurt.png");
    hurtMarker.add(hurtImage);
    hurtToggle = new FlxSpriteGroup(30, -5);
    hurtMarker.add(hurtToggle);
    hurtMarker.visible = false;

    yy += Std.int(injuries.height) + 5;

    var gold = new FlxSprite(xx, yy, "assets/images/gold.png");
    resizeImage(gold, 20, 20);
    goldLbl = new FlxText(xx + 25, yy, 20);
    goldLbl.size = 13;
    goldLbl.text = Std.string(unit.goldCollected.length);
    goldLbl.color = FlxColor.GRAY;

    var treasure = new FlxSprite(xx + 50, yy, "assets/images/item.png");
    resizeImage(treasure, 20, 20);
    treasureLbl = new FlxText(xx + 75, yy, 20);
    treasureLbl.size = 13;
    treasureLbl.text = Std.string(unit.treasureCollected.length);
    treasureLbl.color = FlxColor.GRAY;

    var kills = new FlxSprite(xx + 100, yy, "assets/images/hud/skull.png");
    resizeImage(kills, 20, 20);
    killsLbl = new FlxText(xx + 125, yy, 20);
    killsLbl.size = 13;
    killsLbl.text = Std.string(unit.kills);
    killsLbl.color = FlxColor.GRAY;

    yy += Std.int(kills.height) + 5;

    if (debug) {
      continueBtn = new FlxButton(xx + 70, yy, "Continue", null);
      CharMindAnalysis = new CharMindAnalysis(xx + 15, yy + 30, cast(unit.mind, HeroMind));
      worldMap.cam.followUnit(unit);
    } else {
      follow = new FlxButton(xx + 70, yy, "Follow", OnClickButton);
    }

    add(heroIcon);
    add(emotionIcon);
    add(name);
    add(action);
    add(hearts);
    add(injuries);
    add(hurtMarker);

    add(gold);
    add(goldLbl);
    add(treasure);
    add(treasureLbl);
    add(kills);
    add(killsLbl);

    if (debug) {
      add(continueBtn);
      add(CharMindAnalysis);
    } else {
      add(follow);
    }

    updateCharacterHud();
  }

  function OnClickButton():Void {
    worldMap.cam.followUnit(unit);
  }

  public function updateCharacterHud() {
    action.text = getCharGoalText();
    emotionIcon.loadGraphic("assets/images/emotion/" + Std.string(unit.mind.currentEmotion) + ".png");
    resizeImage(emotionIcon, 20, 20);
    goldLbl.text = Std.string(unit.goldCollected.length);
    treasureLbl.text = Std.string(unit.treasureCollected.length);
    killsLbl.text = Std.string(unit.kills);

    var nHearts:Int = unit.character.hpMax;
    for (i in 0 ... nHearts) {
      if(i < unit.hp) {
        hearts.members[i].animation.play("full");
        hearts.members[i].animation.stop();
      } else {
        hearts.members[i].animation.play("empty");
        hearts.members[i].animation.stop();
      }
    }
    var nInjuries:Int = unit.character.injuryMax;
    for (i in 0 ... nInjuries) {
      if(nInjuries - i > unit.injury) {
        injuries.members[i].animation.play("full");
        injuries.members[i].animation.stop();
      } else {
        injuries.members[i].animation.play("empty");
        injuries.members[i].animation.stop();
      }
    }

    if (unit.injuriesCount > 0) {
      hurtToggle.clear();
      var bg = new FlxSprite();
      hurtToggle.add(bg);
      var yy = 5;
      if (unit.recoverHealthEveryXTurns > 2) {
        var txt = new FlxText(5, yy);
        txt.size = 10;
        txt.text = 'Takes ' + Std.string(unit.recoverHealthEveryXTurns) + ' turns to recover a heart';
        txt.color = FlxColor.BLACK;
        hurtToggle.add(txt);
        yy += 15;
      }
      if (unit.accuracyPenalty > 0) {
        var txt = new FlxText(5, yy);
        txt.size = 10;
        txt.text = 'Has ' + Std.string(unit.accuracyPenalty * 100) + '% less chance to hit';
        txt.color = FlxColor.BLACK;
        hurtToggle.add(txt);
        yy += 15;
      }
      if (unit.critAccuracyPenalty > 0) {
        var txt = new FlxText(5, yy);
        txt.size = 10;
        txt.text = 'Has ' + Std.string(unit.critAccuracyPenalty * 100) + '% less chance to crit';
        txt.color = FlxColor.BLACK;
        hurtToggle.add(txt);
        yy += 15;
      }
      if (unit.visionPenalty > 0) {
        var txt = new FlxText(5, yy);
        txt.size = 10;
        txt.text = 'Has a vision of ' + Std.string(unit.getUnitVision());
        txt.color = FlxColor.BLACK;
        hurtToggle.add(txt);
        yy += 15;
      }

      bg.makeGraphic(250, yy + 5, FlxColor.WHITE);

      hurtMarker.visible = true;
      hurtToggle.visible = false;
      FlxMouseEventManager.remove(hurtImage);
      FlxMouseEventManager.add(hurtImage, null, null, mouseOver, mouseOut);
    }
  }

  private function getCharGoalText():String {
    if (unit.character.goalChar != null) return "protecting " + unit.character.goalChar.name;
    if (unit.character.goalTile == WorldMap.homeTile) return "going home";
    var currentZone:Array<Int> = PositionTool.getZoneForTile(unit.getCoordinate());
    var desiredZone:Array<Int> = PositionTool.getZoneForTile(unit.character.goalTile);
    if(worldMap.isTheSameTile(currentZone, desiredZone)) {
      return "searching on zone " + worldMap.getZoneName(desiredZone);
    } else {
      return "going to zone " + worldMap.getZoneName(desiredZone);
    }
  }

  private function resizeImage(image:FlxSprite, width:Int, height:Int) {
    image.setGraphicSize(width, height);
    image.updateHitbox();
    image.centerOrigin();
  }

  function mouseOver(sprite:FlxSprite) {
    hurtToggle.visible = true;
  }

  function mouseOut(sprite:FlxSprite) {
    hurtToggle.visible = false;
  }

}
