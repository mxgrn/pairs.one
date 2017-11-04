'use strict';
const sh = require('tag-shell');

module.exports = opts => {
  sh.async`notify-send -a ${opts.app} -i ${opts.icon}
    ${opts.title} ${opts.message}
  `;
};
