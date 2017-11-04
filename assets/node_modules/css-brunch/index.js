'use strict';

class CSSCompiler {
  compile(params) {
    return Promise.resolve(params);
  }
}

CSSCompiler.prototype.brunchPlugin = true;
CSSCompiler.prototype.type = 'stylesheet';
CSSCompiler.prototype.extension = 'css';

module.exports = CSSCompiler;
