package intelligence;

import mission.world.Unit;
import mission.world.WorldMap;
import utils.Constants;

interface Mind {
  public var currentEmotion:Emotion;
  public var missedLastAtack:Bool = false;
  public var criticalLastAtack:Bool = false;
  public var wasAtackedLastTurn:Bool = false;

  public function analyseAction(worldMap:WorldMap):Array<Int>;
  public function updateStatus(worldMap:WorldMap):Void;
}
