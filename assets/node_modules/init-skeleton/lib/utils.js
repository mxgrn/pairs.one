'use strict';
const crypto = require('crypto');
const promisify = require('micro-promisify');

const shaDigest = string => {
  return crypto.createHash('sha1').update(string).digest('hex');
};

module.exports = {
  shaDigest,
  exec: promisify(require('child_process').exec),
  mkdirp: promisify(require('mkdirp')),
  ncp: promisify(require('ncp')),
};
