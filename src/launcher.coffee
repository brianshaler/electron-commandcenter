path = require 'path'

electron = require 'electron'

{app, ipcMain} = electron
BrowserWindow = electron.BrowserWindow

window = null

clientPath = path.resolve __dirname, '../client'
viewsPath = path.resolve clientPath, 'views'

Launcher = null

ipcMain.on 'launch', (event, data) ->
  Launcher.hide()

module.exports = Launcher =
  show: ->
    if window?
      window.show()
      return

    window = new BrowserWindow
      frame: true

    window.loadURL "file://#{path.resolve viewsPath, 'launcher.html'}"

    # window.webContents.openDevTools()

    # window.on 'closed', ->
    #   app.quit()

  hide: ->
    window.hide()
