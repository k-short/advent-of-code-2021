const fs = require('fs')
const path = require('path')

const getInputAsList = file => {
  const filePath = path.resolve(__dirname, file)

  try {
    return fs.readFileSync(filePath, 'utf8').split('\n')
  } catch (err) {
    console.error(err)
    return []
  }
}

const getInputAsStringList = file => {
  const filePath = path.resolve(__dirname, file)

  try {
    return fs.readFileSync(filePath, 'utf8')
      .split('\n')
      .map(x => `"${x}"`)
  } catch (err) {
    console.error(err)
    return []
  }
}

module.exports = { getInputAsList, getInputAsStringList }
