package intelligence.debug;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

import intelligence.HeroMind;

import intelligence.tools.EmotionTool;

class TileAnalisys extends FlxSpriteGroup {

  private var analysisTexts:Map<String, FlxText>;
  private var emotionTexts:Map<String, FlxText>;
  private var finalTexts:Map<String, FlxText>;

  private var firstTime:Bool = true;
  public var currentTile:Array<Int>;

  public function new() {
    super();
    this.visible = false;
  }

  public function updateValues(mind:HeroMind, i:Int, j:Int) {
    if (firstTime) firstTimeShowingAnalisys(mind, i, j);
    for (analysis in mind.analyzeWeights.keys()) {
      var analysisValue:Float = getValueForThisTile(mind.analyzeWeights[analysis], i, j);
      var emotionValue:Float = EmotionTool.emotionFactor(mind.unit, analysis);
      var finalValue:Float = round(analysisValue * emotionValue);
      analysisTexts[analysis].text = Std.string(analysisValue);
      emotionTexts[analysis].text = Std.string(emotionValue);
      finalTexts[analysis].text = Std.string(finalValue);
    }
    currentTile = [i,j];
  }

  private function firstTimeShowingAnalisys(mind:HeroMind, i:Int, j:Int) {
    var bg = new FlxSprite();
    add(bg);

    analysisTexts = new Map<String, FlxText>();
    emotionTexts = new Map<String, FlxText>();
    finalTexts = new Map<String, FlxText>();

    var yy = 5;
    for (analysis in mind.analyzeWeights.keys()) {
      yy += analysisDebug(mind, analysis, mind.analyzeWeights[analysis], yy);
    }

    bg.makeGraphic(210, yy + 2, FlxColor.WHITE);
  }

  private function analysisDebug(mind:HeroMind, analysis:String, values:Map<String, Float>, yy:Int):Int {

    var labelText = new FlxText(3, yy, 97);
    labelText.size = 10;
    labelText.text = analysis + ':';
    labelText.alignment = FlxTextAlign.RIGHT;
    labelText.color = FlxColor.GRAY;

    var analysisText = new FlxText(105, yy, 30);
    analysisText.size = 10;
    labelText.alignment = FlxTextAlign.CENTER;
    analysisText.color = FlxColor.BLACK;

    var emotionText = new FlxText(140, yy, 30);
    emotionText.size = 10;
    labelText.alignment = FlxTextAlign.CENTER;
    emotionText.color = FlxColor.RED;

    var finalText = new FlxText(175, yy, 30);
    finalText.size = 10;
    labelText.alignment = FlxTextAlign.CENTER;
    finalText.color = FlxColor.BLACK;

    add(labelText);
    add(analysisText);
    add(emotionText);
    add(finalText);

    analysisTexts[analysis] = analysisText;
    emotionTexts[analysis] = emotionText;
    finalTexts[analysis] = finalText;

    return Std.int(analysisText.height) + 3;
  }

  private function getValueForThisTile(values:Map<String, Float>, i:Int, j:Int):Float {
    var thisTile = '[' + Std.string(i) + ',' + Std.string(j) + ']';
    for (tileString in values.keys()) {
      if (tileString == thisTile) {
        return round(values[tileString]);
      }
    }
    return 0;
  }

  public static function round(number:Float, ?precision=1): Float{
    number *= Math.pow(10, precision);
    return Math.round(number) / Math.pow(10, precision);
  }

}
