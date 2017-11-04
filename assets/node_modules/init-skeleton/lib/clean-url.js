'use strict';
const hostedGitInfo = require('hosted-git-info');
const normalizeGitUrl = require('normalize-git-url');
const loggy = require('loggy');

const cleanURL = address => {
  let git = address.replace(/^gh:/, 'github:');
  const hosted = hostedGitInfo.fromUrl(git);
  if (hosted) {
    git = hosted.git();
  } else {
    loggy.warn(`Couldn't interpret "${git}" as a hosted git url`);
  }

  return normalizeGitUrl(git).url;
};

module.exports = cleanURL;
