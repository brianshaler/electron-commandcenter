path = require 'path'

electron = require 'electron'

{app, ipcMain} = electron
BrowserWindow = electron.BrowserWindow

window = null

viewsPath = path.resolve __dirname, '../lib/views'

Launcher = null

ipcMain.on 'launch', (event, data) ->
  Launcher.hide()

module.exports = Launcher =
  show: (display) ->
    if window?
      window.show()
      window.reload()
      return

    window = new BrowserWindow
      width: 800
      height: Math.round (display?.workArea?.height ? 800) * 0.9
      frame: true

    # load/reload regardless
    window.loadURL "file://#{path.resolve viewsPath, 'launcher.html'}"

    # window.webContents.openDevTools()

    # window.on 'closed', ->
    #   app.quit()

  hide: ->
    window.hide()
