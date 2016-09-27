package intelligence.hero;

import intelligence.Mind;

import mission.world.Unit;
import mission.world.WorldMap;

class HeroMind implements Mind {

  public function new() {
  }

  public function analyseAction(worldMap:WorldMap, unit:Unit):Array<Int> {
    //TODO: TCC
    return unit.getCoordinate();
  }

}
