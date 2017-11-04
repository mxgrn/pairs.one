'use strict';
const all = require('brunch-skeletons').skeletons;
const withAliases = all.filter(skeleton => 'alias' in skeleton);

exports.all = all;
exports.withAliases = withAliases;
exports.urlFor = alias => {
  for (const skeleton of withAliases) {
    if (skeleton.alias === alias) return skeleton.url;
  }
};
