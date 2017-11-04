'use strict';

const fs = require('fs');
const toAbsolute = require('path').resolve;
const cache = new Map();

exports.readFile = path => new Promise((resolve, reject) => {
  const absPath = toAbsolute(path);
  if (cache.has(absPath)) {
    resolve(cache.get(absPath));
    return;
  }
  fs.readFile(absPath, (error, data) => {
    if (error) reject(error);
    else resolve(data);
  });
});

exports.updateCache = path => new Promise((resolve, reject) => {
  const absPath = toAbsolute(path);
  fs.readFile(absPath, (error, data) => {
    if (error) {
      reject(error);
      return;
    }
    cache.set(absPath, data);
    resolve(data);
  });
});
