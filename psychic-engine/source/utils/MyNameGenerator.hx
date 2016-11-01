package utils;

import Random;

import markov.namegen.Generator;

import openfl.Assets;

class MyNameGenerator {

  private static var generator:Generator;

  public static function generateName():String {
    if (generator == null) {
      var json:String = Assets.getText('assets/data/names.json');
      var obj:Array<String> = haxe.Json.parse(json);
      generator = new Generator(obj, 1, 0.02);
    }
    return generator.generate().substr(1, 9);
  }

}
