path = require 'path'

electron = require 'electron'

Launcher = require './launcher'

{app, ipcMain} = electron
electronScreen = null
BrowserWindow = electron.BrowserWindow

displayArray =
  cols: 6
  rows: 2

primaryDisplay = null
windows = null

createWindows = (displaySettings) ->
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
    window.setBounds(bounds, false);

    # window.loadURL('http://mucholol.com/');
    # https://www.youtube.com/watch?v=NeQ0_e7aa8o

    # window.loadURL('http://www.youtube.com/embed/NeQ0_e7aa8o?autoplay=1&loop=1&controls=0&showinfo=0&rel=0&autohide=1&playlist=NeQ0_e7aa8o');
    # window.loadURL('http://www.youtube.com/embed/O4UV_SVGSUU?autoplay=1&loop=1&controls=0&showinfo=0&rel=0&autohide=1&playlist=O4UV_SVGSUU');
    # window.loadURL "file://#{path.resolve __dirname, '..'}/index.html#bounds=#{boundsStr}"
    window.loadURL display.url

    # window.webContents.openDevTools();

    window.on 'closed', ->
      return unless windows?
      _windows = windows
      windows = null
      _windows.forEach (w) ->
        try
          w.close()
        catch ex
          'nothing'
      # app.quit()
      Launcher.show primaryDisplay

    windows.push window

  # and load the index.html of the app.

  # Open the DevTools.
  # mainWindow.webContents.openDevTools();

  # Emitted when the window is closed.
  # mainWindow.on('closed', function() {
  #   # Dereference the window object, usually you would store windows
  #   # in an array if your app supports multi windows, this is the time
  #   # when you should delete the corresponding element.
  #   mainWindow = null;
  # });

ipcMain.on 'launch', (event, data) ->
  createWindows data.displays

# This method will be called when Electron has finished
# initialization and is ready to create browser windows.
app.on 'ready', ->
  electronScreen = electron.screen
  primaryDisplay = electronScreen.getPrimaryDisplay()
  Launcher.show primaryDisplay

# # Quit when all windows are closed.
# app.on 'window-all-closed', ->
#   # On OS X it is common for applications and their menu bar
#   # to stay active until the user quits explicitly with Cmd + Q
#   if process.platform != 'darwin'
#     app.quit()

# app.on 'activate', ->
#   # On OS X it's common to re-create a window in the app when the
#   # dock icon is clicked and there are no other windows open.
#   # if (mainWindow === null) {
#   #   createWindows();
#   # }
