package intelligence;

import mission.world.Unit;
import mission.world.WorldMap;
import utils.Constants;

interface Mind {
  public var currentEmotion:Emotion;
  public function analyseAction(worldMap:WorldMap):Array<Int>;
  public function updateStatus(worldMap:WorldMap):Void;
}
