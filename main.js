'use strict';

const electron = require('electron');
// Module to control application life.
const app = electron.app;
// Module to create native browser window.
const BrowserWindow = electron.BrowserWindow;

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let windows = [];

function createWindows () {
  // Create the browser window.
  let electronScreen = electron.screen;
  let displays = electronScreen.getAllDisplays();

  // console.log(displays);

  let totalWidth = displays.reduce(function (memo, display) {
    let right = display.bounds.x + display.bounds.width;
    memo = memo > right ? memo : right;
    return memo;
  }, 0);
  let totalHeight = displays.reduce(function (memo, display) {
    let bottom = display.bounds.y + display.bounds.height;
    memo = memo > bottom ? memo : bottom;
    return memo;
  }, 0);

  let displays1 = [
    {
      bounds: {
        x: 0,
        y: 0,
        width: totalWidth / 3,
        height: totalHeight
      }
    },
    {
      bounds: {
        x: totalWidth / 3,
        y: 0,
        width: totalWidth / 3,
        height: totalHeight
      }
    },
    {
      bounds: {
        x: totalWidth * 2 / 3,
        y: 0,
        width: totalWidth / 3,
        height: totalHeight
      }
    }
  ];



  let displays2 = [
    {
      bounds: {
        x: 0,
        y: 0,
        width: totalWidth / 3,
        height: totalHeight / 2
      }
    },
    {
      bounds: {
        x: 0,
        y: totalHeight / 2,
        width: totalWidth / 6,
        height: totalHeight / 2
      }
    },
    {
      bounds: {
        x: totalWidth / 6,
        y: totalHeight / 2,
        width: totalWidth / 6,
        height: totalHeight / 2
      }
    },
    {
      bounds: {
        x: totalWidth / 3,
        y: 0,
        width: totalWidth / 3,
        height: totalHeight
      }
    },
    {
      bounds: {
        x: totalWidth * 2 / 3,
        y: 0,
        width: totalWidth / 6,
        height: totalHeight
      }
    },
    {
      bounds: {
        x: totalWidth * 5 / 6,
        y: 0,
        width: totalWidth / 6,
        height: totalHeight / 2
      }
    },
    {
      bounds: {
        x: totalWidth * 5 / 6,
        y: totalHeight / 2,
        width: totalWidth / 6,
        height: totalHeight / 2
      }
    }
  ];

  displays = displays2;

  for (let d = 0; d < displays.length; d++) {
    let display = displays[d];
    let bounds = {
      x: display.bounds.x,
      y: display.bounds.y,
      width: display.bounds.width,
      height: display.bounds.height
    };
    let boundsStr = [
      bounds.x,
      bounds.y,
      bounds.width,
      bounds.height,
      totalWidth,
      totalHeight
    ].join(',')

    let window = new BrowserWindow({
      x: bounds.x + 100,
      y: bounds.y + 100,
      width: bounds.width,
      height: bounds.height,
      enableLargerThanScreen: true,
      frame: false
    });
    window.setBounds(bounds, false);

    window.loadURL('http://mucholol.com/');
    // https://www.youtube.com/watch?v=NeQ0_e7aa8o

    // window.loadURL('http://www.youtube.com/embed/NeQ0_e7aa8o?autoplay=1&loop=1&controls=0&showinfo=0&rel=0&autohide=1&playlist=NeQ0_e7aa8o');
    // window.loadURL('http://www.youtube.com/embed/O4UV_SVGSUU?autoplay=1&loop=1&controls=0&showinfo=0&rel=0&autohide=1&playlist=O4UV_SVGSUU');
    // window.loadURL('file://' + __dirname + '/index.html#bounds=' + boundsStr);

    // window.webContents.openDevTools();

    window.on('closed', function () {
      app.quit();
    });

    windows.push(window);
  }

  // and load the index.html of the app.

  // Open the DevTools.
  // mainWindow.webContents.openDevTools();

  // Emitted when the window is closed.
  // mainWindow.on('closed', function() {
  //   // Dereference the window object, usually you would store windows
  //   // in an array if your app supports multi windows, this is the time
  //   // when you should delete the corresponding element.
  //   mainWindow = null;
  // });
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on('ready', createWindows);

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  // if (mainWindow === null) {
  //   createWindows();
  // }
});
