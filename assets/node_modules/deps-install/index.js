'use strict';

const exists = require('fs').existsSync;
const cp = require('child_process');
const join = require('path').join;
const loggy = require('loggy');
const promisify = require('micro-promisify');
const exec = promisify(cp.exec);

// Force colors in `exec` outputs
process.env.FORCE_COLOR = 'true';
process.env.NPM_CONFIG_COLOR = 'always';

const installed = cmd => {
  // shell: true must be set for this test to work on non *nixes.
  return !cp.spawnSync(cmd, ['--version'], {shell: true}).error;
};

const getInstallCmd = {
  package: rootPath => {
    const pkgPath = join(rootPath, 'package.json');
    if (!exists(pkgPath)) return;

    if (installed('yarn')) {
      const lockPath = join(rootPath, 'yarn.lock');
      if (exists(lockPath)) return 'yarn';
    }

    return 'npm';
  },
  bower: rootPath => {
    const bowerPath = join(rootPath, 'bower.json');
    if (exists(bowerPath) && installed('bower')) return 'bower';
  },
};

module.exports = options => {
  if (options == null) options = {};

  const rootPath = options.rootPath || '.';
  const pkgType = [].concat(options.pkgType || []);
  const logger = options.logger || loggy;
  const env = process.env.NODE_ENV === 'production' ? '--production' : '';

  const prevDir = process.cwd();
  process.chdir(rootPath);

  const execs = pkgType.map(type => {
    const cmd = getInstallCmd[type](rootPath);
    if (!cmd) return;
    logger.info(`Installing packages with ${cmd}...`);
    return exec(`${cmd} install ${env}`);
  });

  return Promise.all(execs).then(() => {
    process.chdir(prevDir);
  }, error => {
    process.chdir(prevDir);
    error.code = 'INSTALL_DEPS_FAILED';
    logger.error(error);
    throw error;
  });
};
