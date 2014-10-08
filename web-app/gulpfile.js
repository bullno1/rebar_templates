var gulp  = require('gulp');
var gutil = require('gulp-util');
var uglify = require('gulp-uglify');
var source = require('vinyl-source-stream');
var browserify = require('browserify');
var watchify = require('watchify');
var sourcemaps = require('gulp-sourcemaps');
var buffer = require('vinyl-buffer');
var del = require('del');

var package = require("./package.json");
var vendor = Object.keys(package.dependencies);

gulp.task("default", ["browserify-nowatch"]);
gulp.task("watch", ["browserify-watch"]);
gulp.task("clean", function(cb) {
	del(["priv/www/js"], cb);
});

gulp.task("browserify-watch", ["browserify-vendor"], function() {
	return bundleApp(true);
});

gulp.task("browserify-nowatch", ["browserify-vendor"], function() {
	return bundleApp(false);
});

gulp.task("browserify-vendor", function() {
	b = browserify({
		debug: true,
		noparse: vendor,
	});
	vendor.forEach(b.require.bind(b));
	return writeBundle(b, "vendor.js");
});

function bundleApp(watch) {
	var b = browserify("./js_src/main.js", {
		debug: true,
		noparse: vendor,
		cache: {},
		packageCache: {},
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

	return writeBundle(b, bundleName);
}

function writeBundle(b, name) {
	return b
		.bundle()
		.on("error", function(e) { gutil.log("Browserify:", e.message); this.end(); })
		.pipe(source(name))
		.pipe(buffer())
		.pipe(sourcemaps.init({loadMaps:true}))
		.pipe(uglify())
		.pipe(sourcemaps.write("./priv/www/js"))
		.pipe(gulp.dest("./priv/www/js"));
}
