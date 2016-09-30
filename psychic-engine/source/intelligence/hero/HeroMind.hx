package intelligence.hero;

import intelligence.Mind;

import mission.world.Unit;
import mission.world.WorldMap;

import intelligence.tools.PositionTool;

class HeroMind implements Mind {

  public function new() {
  }

  public function analyseAction(worldMap:WorldMap, unit:Unit):Array<Int> {
    var tilesWeights = createOptions(worldMap, unit);

    tilesWeights = movingAnalysis(worldMap, unit, tilesWeights);
    tilesWeights = survivorAnalysis(worldMap, unit, tilesWeights);
    tilesWeights = lootAnalysis(worldMap, unit, tilesWeights);
    tilesWeights = friendsAnalysis(worldMap, unit, tilesWeights);

    return getBestOption(tilesWeights);
  }

  public function createOptions(worldMap:WorldMap, unit:Unit):Map<Array<Int>, Int> {
    var validTiles:Array<Array<Int>> = PositionTool.getValidTilesInRange(worldMap, unit.getCoordinate(), unit.character.vision);
    var tilesWeights:Map<Array<Int>, Int> = new Map<Array<Int>, Int>();
    for (tile in validTiles) {
      tilesWeights.set(tile, 1);
    }
    return tilesWeights;
  }

  public function movingAnalysis(worldMap:WorldMap, unit:Unit, tilesWeights:Map<Array<Int>, Int>):Map<Array<Int>, Int> {
    /* TODO:
    - Distância do ponto destino (quanto mais próximo, maior o peso), os pontos destino podem ser:
      - Quadrante ao qual o personagem foi designado (durante a etapa ativa) ou posição do personagem que deve proteger.
      - Acampamento
      - Nenhum, caso já esteja no quadrante destino designado.
    - Estando no quadrante designado durante a etapa ativa os pesos, para as casas, buscam:
      - Maximizar o número de casas (pertencentes ao quadrante destino) que passarão a ser conhecidas caso eu me movimente para aquela casa. */
    return tilesWeights;
  }
  public function survivorAnalysis(worldMap:WorldMap, unit:Unit, tilesWeights:Map<Array<Int>, Int>):Map<Array<Int>, Int> {
    /* TODO:
    - Cada monstro (mais forte que o personagem) possui um raio de periculosidade em volta de si onde dentro dele cada casa possui um grau de perigo igual a soma dos graus de perigos individuais de cada monstro.
      - Cada monstro possui um grau de perigo (mais forte, igual ou mais fraco que o personagem).
    - As casas onde se encontram os monstro possuem um peso próprio proporcional à chance de sucesso numa briga direta com o monstro.
    */
    return tilesWeights;
  }
  public function lootAnalysis(worldMap:WorldMap, unit:Unit, tilesWeights:Map<Array<Int>, Int>):Map<Array<Int>, Int> {
    /* TODO:
    - Comida recebem um peso relativo a necessidade de carne do player. Para isso o player deve definir uma meta de carne a ser obtida durante a missão
    - Tesouros recebem um peso positivo
    */
    return tilesWeights;
  }
  public function friendsAnalysis(worldMap:WorldMap, unit:Unit, tilesWeights:Map<Array<Int>, Int>):Map<Array<Int>, Int> {
    /* TODO:
    - Peso na casa dos monstros (passíveis de atacar um amigo) relativo ao grau de perigo que ele exerce sobre o outro personagem levando em conta o grau de afinidade bem como a distância do monstro
    - Peso gradiente que irradia de outro personagem (dentro do campo de visão) diretamente proporcional a distância e ao grau de afinidade
    */
    return tilesWeights;
  }

  public function getBestOption(tilesWeights:Map<Array<Int>, Int>):Array<Int> {
    var bestOption:Array<Int> = null;
    var bestOptionValue = 0;

    for(key in tilesWeights.keys()) {
      if(tilesWeights[key] > bestOptionValue || bestOption == null) {
        bestOptionValue = tilesWeights[key];
        bestOption = key;
      }
    }

    return bestOption;
  }

}
