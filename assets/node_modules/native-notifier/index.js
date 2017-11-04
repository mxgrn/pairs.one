'use strict';
const os = require('os').platform();

module.exports = (() => {
  switch (os) {
    case 'darwin': return require('./macos');
    case 'linux': return require('./linux');
    case 'win32': return require('./windows');
  }

  return () => {};
})();
