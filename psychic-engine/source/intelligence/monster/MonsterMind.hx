package intelligence.monster;

import intelligence.Mind;
import mission.world.WorldMap;

class MonsterMind implements Mind {

  public function new() {
  }

  public function analyseAction(worldMap:WorldMap):Array<Int> {
    //TODO: create basic logic for dummy enemy
    return [0,0];
  }
}
