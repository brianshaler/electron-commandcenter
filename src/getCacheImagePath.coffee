path = require 'path'
crypto = require 'crypto'

Promise = require 'when'
mkdirp = require 'mkdirp'

cacheDir = path.resolve __dirname, '../cache'

cacheDirPromise = Promise.promise (resolve, reject) ->
  mkdirp cacheDir, (err) ->
    return reject err if err
    resolve cacheDir

makeFileName = (url, width, height) ->
  console.log 'makeFileName', url, width, height
  hash = crypto
    .createHash 'md5'
    .update String(width) + String(height) + url
    .digest 'hex'
  "#{hash}.png"

getCacheImagePath = (url, width, height) ->
  cacheDirPromise
  .then (cacheDir) ->
    path.join cacheDir, makeFileName url, width, height

getCacheImagePath.sync = (url, width, height) ->
  path.join cacheDir, makeFileName url, width, height

module.exports = getCacheImagePath
