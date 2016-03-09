gulp = require 'gulp'
autowatch = require 'gulp-autowatch'
coffee = require 'gulp-coffee'
changed = require 'gulp-changed'

paths =
  coffee: 'src/**/*.coffee'
  assets: 'assets/**'

gulp.task 'assets', ->
  gulp.src paths.assets
  .pipe gulp.dest 'lib'

gulp.task 'coffee', ->
  gulp.src paths.coffee
  .pipe changed 'lib'
  .pipe coffee()
  .pipe gulp.dest 'lib'

gulp.task 'watch', Object.keys(paths), ->
  autowatch gulp, paths

gulp.task 'default', ['coffee', 'assets']
