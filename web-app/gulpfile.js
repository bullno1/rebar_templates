var gulp  = require('gulp');
var gutil = require('gulp-util');
var uglify = require('gulp-uglify');
var source = require('vinyl-source-stream');
var browserify = require('browserify');
var less = require('gulp-less');
var watchify = require('watchify');
var sourcemaps = require('gulp-sourcemaps');
var buffer = require('vinyl-buffer');
var del = require('del');
var exec = require('child_process').exec;

//include all dependencies in the vendor bundle
var package = require("./package.json");
var vendor = Object.keys(package.dependencies);

gulp.task("default", ["browserify-nowatch", "less"]);
gulp.task("watch", ["browserify-watch", "less-watch"]);
gulp.task("clean", function(cb) {
	del(["priv/www/js", "priv/www/css"], cb);
});

gulp.task("browserify-watch", ["browserify-vendor"], function() {
	return bundleApp(true);
});

gulp.task("browserify-nowatch", ["browserify-vendor"], function() {
	return bundleApp(false);
});

gulp.task("browserify-vendor", function() {
	var b = browserify({
		debug: true,
		noparse: vendor,
	});
	vendor.forEach(b.require.bind(b));
	return writeBundle(b, "vendor.js");
});

gulp.task("less", function() {
	gulp
		.src("./less_src/*.less")
		.pipe(less({
			compress: true,
			strictMath: true
		}))
		.on("error", function(e) { gutil.log("less:", e.message); })
		.pipe(gulp.dest("priv/www/css"));
});

gulp.task("less-watch", function() {
	gulp.watch("less_src/*.less", ["less"]);
});

function bundleApp(watch) {
	var b = browserify("./js_src/main.js", {
		debug: true,
		noparse: vendor,
		cache: {},
		packageCache: {},
		transform: ["brfs", "strictify"],
		fullPaths: true
	});

	var bundleName = "app.js";

	if(watch) {
		b = watchify(b);
		b
			.on("update", function() {
				return writeBundle(b, bundleName);
			})
			.on("log", gutil.log.bind(gutil, "Browserify:"));
	}

	vendor.forEach(b.external.bind(b));

	return writeBundle(b, bundleName, !watch);
}

function writeBundle(b, name, exitOnError) {
	return b
		.bundle()
		.on("error", function(e) {
			gutil.log("Browserify:", e.message);
			this.end();
			if(exitOnError) {
				process.exit(1);
			}
		})
		.pipe(source(name))
		.pipe(buffer())
		.pipe(sourcemaps.init({loadMaps:true}))
		.pipe(uglify())
		.pipe(sourcemaps.write("./"))
		.pipe(gulp.dest("./priv/www/js"));
}
