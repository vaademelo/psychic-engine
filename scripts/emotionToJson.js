const fs = require('fs');

function init (csvFile) {
  let lines = csvFile.split('\r\n');
  let header = lines.shift();

  let emotions = defineEmotions(header);
  let emotionsWeights = defineWeights(lines, emotions);
  console.log(emotionsWeights);
  return JSON.stringify(emotionsWeights, null, 2);
}

function defineEmotions(header) {
  var cells = header.split(',');
  cells.shift();
  var emotions = [];

  for (let cell of cells) {
    let name = cell;
    if (name === '') continue;
    emotions.push(name.toLowerCase());
  }

  return emotions;
}

function defineWeights(lines, emotions) {
  var emotionsWeights = {};

  for (let emotion of emotions) {
    emotionsWeights[emotion] = {};
  }

  for (let line of lines) {
    let cells = line.split(',');
    let weight = cells.shift();
    if (weight === '') continue;

    for (let i = 0; i < cells.length; i++) {
      let cell = cells[i];
      if (cell === '') continue;
      emotionsWeights[emotions[i]][weight] = cell;
    }
  }

  return emotionsWeights;
}

module.exports = init;
