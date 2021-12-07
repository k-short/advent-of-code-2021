// Concept from https://github.com/jxxcarlson/elm-platform

// Link to compiled Elm code main.js
const Elm = require('./main').Elm
const main = Elm.Main.init()
const { getInputAsList, getInputAsStringList } = require('./util.js')

// Get the day number from the command line
const args = process.argv.slice(2)
const inputDay = args[0]

let inputData
switch (inputDay) {
  case 'day-1':
    inputData = getInputAsList(`../input/${inputDay}.txt`)
    break;
  case 'day-2':
    inputData = getInputAsStringList(`../input/${inputDay}.txt`)
    break
  default:
    inputData = null
}

if (inputData != null) {
  const input = `{"tag": "${inputDay}", "input": [${inputData}]}`

  // Send data to the worker
  main.ports.get.send(JSON.parse(input))

  // Get data from the worker
  main.ports.put.subscribe(function(data) {
    console.log("   Output: " + JSON.stringify(data) + "\n")
  })
} else {
  console.log(`\n   Invalid argument: ${inputDay}`)
}