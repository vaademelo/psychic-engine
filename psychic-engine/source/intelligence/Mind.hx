package intelligence;

import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;
import utils.Constants;

interface Mind {
  public var currentEmotion:Emotion;

  public var opponentsInRange:Array<Unit>;
  public var friendsInRange:Array<Unit>;
  public var goldsInRange:Array<Collectable>;
  public var treasuresInRange:Array<Collectable>;

  public var missedLastAtack:Bool = false;
  public var criticalLastAtack:Bool = false;
  public var wasAtackedLastTurn:Bool = false;
  public var enemyDiedLastTurn:Bool = false;
  public var friendDiedLastTurn:Bool = false;

  public function analyseAction(worldMap:WorldMap):Array<Int>;
  public function updateStatus(worldMap:WorldMap):Void;
}
