fs = require 'fs'
path = require 'path'
crypto = require 'crypto'

_ = require 'lodash'
electron = require 'electron'
mkdirp = require 'mkdirp'
Promise = require 'when'

Launcher = require './launcher'

{app, ipcMain} = electron
electronScreen = null
BrowserWindow = electron.BrowserWindow

displayArray =
  cols: 6
  rows: 2

primaryDisplay = null
windows = null
counter = 0

cacheDirPromise = Promise.promise (resolve, reject) ->
  dirName = path.resolve __dirname, '../cache'
  mkdirp dirName, (err) ->
    return reject err if err
    resolve dirName

getCacheImagePath = (url, width, height) ->
  cacheDirPromise
  .then (cacheDir) ->
    hash = crypto
      .createHash 'md5'
      .update String(width) + String(height) + url
      .digest 'hex'
    path.join cacheDir, "#{hash}.png"

closeWindows = ->
  return unless windows?.length > 0
  _windows = windows
  windows = null
  _windows.forEach (w) ->
    try
      w.close()
    catch ex
      'nothing'

createWindows = (displaySettings) ->
  if windows?.length > 0
    closeWindows()
  windows = []
  # Create the browser window.
  displays = electronScreen.getAllDisplays()

  # console.log(displays);

  minX = displays.reduce (memo, display) ->
    left = display.workArea.x
    memo = left unless memo < left
    memo
  , Infinity
  minY = displays.reduce (memo, display) ->
    top = display.workArea.y
    memo = top unless memo < top
    memo
  , Infinity
  totalWidth = displays.reduce (memo, display) ->
    right = display.workArea.x + display.workArea.width
    memo = right unless memo > right
    memo
  , 0
  totalHeight = displays.reduce (memo, display) ->
    bottom = display.workArea.y + display.workArea.height
    memo = bottom unless memo > bottom
    memo
  , 0

  # totalWidth -= minX;
  # totalHeight -= minY;

  console.log minX, minY, totalWidth, totalHeight

  displays = displaySettings.map (display) ->
    url: display.url
    bounds:
      x: Math.floor minX + display.x / displayArray.cols * totalWidth
      y: Math.floor minY + display.y / displayArray.rows * totalHeight
      width: Math.ceil display.width / displayArray.cols * totalWidth
      height: Math.ceil display.height / displayArray.rows * totalHeight

  console.log 'displays', displays

  displays.forEach (display) ->
    bounds =
      x: Math.floor display.bounds.x
      y: Math.floor display.bounds.y
      width: Math.ceil display.bounds.width
      height: Math.ceil display.bounds.height
    boundsStr = [
      bounds.x
      bounds.y
      bounds.width
      bounds.height
      totalWidth
      totalHeight
    ].join ','
    console.log boundsStr

    window = new BrowserWindow
      x: bounds.x
      y: bounds.y
      width: bounds.width
      height: bounds.height
      enableLargerThanScreen: true
      frame: false
    window._id = counter++
    window.setBounds bounds, false

    setTimeout ->
      win = _.find windows, (w) -> w == window
      return unless win?
      getCacheImagePath display.url, bounds.width, bounds.height
      .then (fileName) ->
        Promise.promise (resolve, reject) ->
          fs.exists fileName, (exists) ->
            if exists
              resolve false
            else
              resolve fileName
      .then (fileName) ->
        return unless fileName
        Promise.promise (resolve, reject) ->
          window.capturePage (img) ->
            png = img?.toPng?()
            resolve png
        .then (imgBuffer) ->
          return unless imgBuffer
          fs.writeFile fileName, imgBuffer, (err) ->
            return console.log err if err
    , 5000

    window.loadURL display.url

    window.on 'closed', ->
      closeWindows()
      console.log 'windows closed, show launcher', arguments
      Launcher.show primaryDisplay

    windows.push window

ipcMain.on 'launch', (event, data) ->
  createWindows data.displays

app.on 'ready', ->
  electronScreen = electron.screen
  primaryDisplay = electronScreen.getPrimaryDisplay()
  Launcher.show primaryDisplay
