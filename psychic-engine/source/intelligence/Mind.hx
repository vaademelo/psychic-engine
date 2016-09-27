package intelligence;

import mission.world.WorldMap;

interface Mind {
  public function analyseAction(worldMap:WorldMap):Array<Int>;
}
