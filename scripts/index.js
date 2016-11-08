const fs = require('fs');
const personalityToJson = require('./personalityToJson');
const emotionToJson = require('./emotionToJson');

function generateJsons() {
  let personalityFile = fs.readFileSync('./Personality.csv','utf8');
  let json = personalityToJson(personalityFile);
  fs.writeFile(__dirname + '/../psychic-engine/assets/data/personalityTraits.json', json);

  let emotionFile = fs.readFileSync('./emotion.csv','utf8');
  json = emotionToJson(emotionFile);
  fs.writeFile(__dirname + '/../psychic-engine/assets/data/emotionWeights.json', json);
}

generateJsons();
