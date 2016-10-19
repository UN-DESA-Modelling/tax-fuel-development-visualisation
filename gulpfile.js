var fs         = require('fs');
var gulp       = require('gulp');
var coffee     = require('gulp-coffee');
var gutil      = require('gulp-util');
var concat     = require('gulp-concat');
var uglify     = require('gulp-uglify');
var sourcemaps = require('gulp-sourcemaps');

var dist    = './dist/javascripts/';
var coffees = './coffee/*.coffee';

gulp.task('build:coffees-dev', function() {
  gulp.src(coffees)
    .pipe(sourcemaps.init())
    .pipe(coffee({ bare: true }))
    .on('error', function(e) {
      gutil.beep();
      gutil.log(gutil.colors.red(e));
    })
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(dist));
});

gulp.task('watch', function() {
  gulp.start('build:coffees-dev');
  gulp.watch(coffees, ['build:coffees-dev']);
});

gulp.task('default', function() {
  gulp.start('build:coffees-dev');
});
