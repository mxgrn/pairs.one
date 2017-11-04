'use strict';
const logger = require('.');

logger.log('Hello, loggy');
logger.warn('Deprecated');
logger.info(new Date());
logger.error('$PATH');

setTimeout(() => {
  logger.error(new TypeError('undefined is not a function'));
  logger.dumpStacks = true;

  setTimeout(() => {
    logger.error(new TypeError('stack is shown'));
  }, 1000);
}, 1000);
