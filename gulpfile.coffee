gulp = require 'gulp'
autowatch = require 'gulp-autowatch'
coffee = require 'gulp-coffee'
changed = require 'gulp-changed'

paths =
  coffee: 'src/**/*.coffee'
  scripts: 'src/public/**/*.coffee'
  assets: 'assets/**'

gulp.task 'assets', ->
  gulp.src paths.assets
  .pipe gulp.dest 'client'

gulp.task 'coffee', ->
  gulp.src paths.coffee
  .pipe changed 'lib'
  .pipe coffee()
  .pipe gulp.dest 'lib'

gulp.task 'scripts', ->
  gulp.src paths.scripts
  .pipe changed 'client/scripts'
  .pipe coffee()
  .pipe gulp.dest 'client/scripts'

gulp.task 'watch', Object.keys(paths), ->
  autowatch gulp, paths

gulp.task 'default', ['coffee', 'assets', 'scripts']
