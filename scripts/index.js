const fs = require('fs');

function init () {
  let csvFile = fs.readFileSync('./Personality.csv','utf8');
  let lines = csvFile.split('\r\n');
  let header = lines.shift();

  let triggers = defineTriggers(header);
  let traits = defineTraits(lines, triggers);
  let json = JSON.stringify({'triggers':triggers, 'traits':traits}, null, 2);

  fs.writeFile(__dirname + '/../psychic-engine/assets/data/personalityTraits.json', json);
}

function defineTriggers(header) {
  var cells = header.split(',');
  cells.shift();
  var triggers = [];

  for (let cell of cells) {
    let name = cell;
    if (name === '') name = 'not' + triggers[triggers.length - 1].toProperCase();
    triggers.push(name.toLowerCase());
  }

  return triggers;
}

function defineTraits(lines, triggers) {
  var traits = {};

  for (let line of lines) {
    let cells = line.split(',');
    let traitName = cells.shift();
    if (traitName === '') continue;

    traits[traitName] = defineEffects(cells, triggers);
  }

  return traits;
}

function defineEffects(cells, triggers) {
  let values = {};
  let index = 0;

  for (let cell of cells) {
    let value = cell;
    if (value === '') value = 'peaceful';

    let trigger = triggers[index];
    if (!trigger.startsWith('not')) {
      values[trigger] = [value];
    } else {
      trigger = trigger.replace("not","");
      values[trigger].push(value);
    }
    index ++;
  }

  for (let trigger of Object.keys(values)) {
    if (values[trigger].length == 1) {
      values[trigger].push('peaceful');
    }
  }

  return values;
}

String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

init();
