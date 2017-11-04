'use strict';
const skeletons = require('./skeletons');
const suggestedCount = 8;
const othersCount = skeletons.all.length - suggestedCount;

const printBanner = commandName => {
  if (!commandName) commandName = 'init-skeleton';

  const suggestions = skeletons.withAliases
    .slice(0, suggestedCount)
    .map(skeleton => {
      return `* ${commandName} ${skeleton.alias} - ${skeleton.description}`;
    })
    .join('\n');

  const error = new Error(
`You should specify skeleton (boilerplate) from which new app will be initialized.

Pass skeleton name or URL like that:

${commandName} simple
${commandName} https://github.com/brunch/dead-simple

A few popular skeletons:

${suggestions}

Other ${othersCount} boilerplates are available at
http://brunch.io/skeletons`
  );

  error.code = 'SKELETON_MISSING';

  return Promise.reject(error);
};

module.exports = printBanner;
