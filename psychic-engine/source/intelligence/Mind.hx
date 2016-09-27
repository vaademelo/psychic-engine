package intelligence;

import mission.world.Unit;
import mission.world.WorldMap;

interface Mind {
  public function analyseAction(worldMap:WorldMap, unit:Unit):Array<Int>;
}
