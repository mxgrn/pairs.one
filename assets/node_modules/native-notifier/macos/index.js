'use strict';
const tmpdir = require('os').tmpdir();
const exists = require('fs').existsSync;
const sh = require('tag-shell');

const appsDir = `${tmpdir}/loggy`;
const notify = `${__dirname}/notify.js`;

sh`mkdir -p ${appsDir}`;

const getAppPath = (appName, iconSrc) => {
  const appPath = `${appsDir}/${appName}.app`;
  if (!exists(appPath)) {
    sh`osacompile -l JavaScript -o ${appPath} ${notify}`;

    const iconDest = `${appPath}/Contents/Resources/applet.icns`;
    sh`sips -s format icns ${iconSrc} --out ${iconDest}`;

    const bundleId = `com.paulmillr.loggy.${appName}`;
    const plistPath = `${appPath}/Contents/Info.plist`;
    sh`plutil -replace CFBundleIdentifier -string ${bundleId} ${plistPath}`;
    sh`plutil -replace LSBackgroundOnly -bool YES ${plistPath}`;
  }

  return appPath;
};

module.exports = opts => {
  const appPath = getAppPath(opts.app, opts.icon);
  const env = {
    TITLE: opts.title,
    MESSAGE: opts.message,
  };

  sh.async({env})`open -a ${appPath}`;
};
