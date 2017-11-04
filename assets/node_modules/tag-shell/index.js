'use strict';
const tag = (spawn, options) => function(arg) {
  if (!Array.isArray(arg)) return tag(spawn, arg);

  const args = [];

  arg.forEach((string, index) => {
    string.split(/\s+/).forEach(arg => {
      if (arg) args.push(arg);
    });

    const arg = arguments[index + 1];
    if (arg != null) args.push(arg);
  });

  const cmd = args.shift();

  return spawn(cmd, args, options);
};

const sync = function() {
  const proc = cp.spawnSync.apply(cp, arguments);
  if (proc.error) throw proc.error;
  if (proc.status) throw new Error(`${proc.stderr}`.trim());

  return `${proc.stdout}`.trim();
};

const cp = require('child_process');
const sh = tag(sync);
sh.sync = sh;
sh.async = tag(cp.spawn);

module.exports = sh;
