const fs = require('fs');

function init () {
  let csvFile = fs.readFileSync('./Personality.csv','utf8');
  let lines = csvFile.split('\r\n');
  let header = lines.shift();

  let triggers = defineTriggers(header);
  let traits = defineTraits(lines, triggers);
  let json = JSON.stringify(traits, null, 2);

  fs.writeFile('personalityTraits.json', json);
}

function defineTriggers(header) {
  var cells = header.split(',');
  cells.shift();
  var triggers = [];

  for (let cell of cells) {
    let name = cell;
    if (name === '') name = 'not' + triggers[triggers.length - 1].toProperCase();
    triggers.push(name);
  }

  return triggers;
}

function defineTraits(lines, triggers) {
  var traits = {};

  for (let line of lines) {
    let cells = line.split(',');
    let traitName = cells.shift();
    let values = {};

    if (traitName === '') continue;
    for (let cell of cells) {
      let value = cell;
      if (value === '') value = 'empty';
      let index = Object.keys(values).length;
      console.log(index, triggers[index], value);
      values[triggers[index]] = value;
    }

    traits[traitName] = values;
  }

  return traits;
}

String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

init();
