'use strict';
const exists = require('fs').existsSync;
const sysPath = require('path');
const install = require('deps-install');
const skeletons = require('./skeletons');
const cleanURL = require('./clean-url');
const printBanner = require('./print-banner');

const shaDigest = require('./utils').shaDigest;
const mkdirp = require('./utils').mkdirp;
const exec = require('./utils').exec;
const ncp = require('./utils').ncp;

const homeDir = require('os').homedir();
const cacheDir = sysPath.join(homeDir, '.brunch', 'skeletons');
const rwxrxrx = 0o755;

// Main function that clones or copies the skeleton.
//
// skeleton - String, file system path or URI of skeleton.
// options - Object (optional)
//
// Returns Promise.
const initSkeleton = (alias, options) => {
  if (options == null) options = {};

  const cwd = process.cwd();
  const rootPath = sysPath.resolve(options.rootPath || cwd);
  const logger = options.logger || console;

  if (alias == null || alias === '.' && rootPath === cwd) {
    return printBanner(options.commandName);
  }

  const pkgPath = sysPath.join(rootPath, 'package.json');
  if (exists(pkgPath)) {
    const error = new Error(`Directory "${rootPath}" is already an npm project`);
    error.code = 'ALREADY_NPM_PROJECT';
    return Promise.reject(error);
  }

  // Clones skeleton from URI. Returns Promise.
  const clone = () => mkdirp(cacheDir).then(() => {
    const url = cleanURL(skeleton);
    const repoDir = sysPath.join(cacheDir, shaDigest(url));

    if (exists(repoDir)) {
      const gitPull = 'git pull origin master';
      logger.log(`Pulling recent changes from git repo "${url}" to "${repoDir}"...`);

      return exec(gitPull, {cwd: repoDir}).then(() => {
        logger.log(`Pulled master into "${repoDir}"`);
        return repoDir;
      }, error => {
        // Only true if `yarn` is used
        logger.log(`Could not pull, using cached version (${error})`);
      });
    }

    const gitClone = `git clone ${url} "${repoDir}"`;
    logger.log(`Cloning git repo "${url}" to "${repoDir}"...`);

    return exec(gitClone).then(() => {
      logger.log(`Cloned "${url}" into "${repoDir}"`);
      return repoDir;
    }, error => {
      throw new Error(`Git clone error: ${error}`);
    });
  });

  // Copy skeleton from file system. Returns Promise.
  const copy = repoDir => mkdirp(rootPath, rwxrxrx).then(() => {
    const filter = path => !/^\.(git|hg)$/.test(sysPath.basename(path));
    logger.log(`Copying local skeleton to "${rootPath}"...`);

    return ncp(repoDir, rootPath, {filter});
  });

  const skeleton = skeletons.urlFor(alias) || alias;
  const copyPath = exists(skeleton) ? Promise.resolve(skeleton) : clone();

  return copyPath.then(copy).then(() => {
    logger.log('Created skeleton directory layout');

    const pkgType = ['package', 'bower'];
    return install({rootPath, pkgType, logger});
  });
};

exports.init = initSkeleton;
exports.cleanURL = cleanURL;
exports.printBanner = commandName => {
  return printBanner(commandName).catch(error => {
    console.log(error.message);
  });
};
