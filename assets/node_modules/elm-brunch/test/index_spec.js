var chai = require('chai')
  , sinon = require('sinon')
  , sinonChai = require('sinon-chai')
  , expect = chai.expect;

chai.use(sinonChai);

var ElmCompiler = require('../index')
  , execSync;

describe('ElmCompiler', function (){
  var elmCompiler, baseConfig = {
        paths: {
          public: 'test/public/folder'
        },
        plugins: {
          elmBrunch: {}
        }
      };

  describe('plugin', function () {
    beforeEach(function () {
      elmCompiler = new ElmCompiler(baseConfig);
    });

    it('is an object', function () {
      expect(elmCompiler).to.be.ok;
    });

    it('has a #compile method', function () {
      expect(elmCompiler.compile).to.be.an.instanceof(Function);
    });
  });

  describe('elm config', function () {
    describe('outputFolder', function () {
      describe('when an outputFolder is not specified', function () {
        beforeEach(function () {
          elmCompiler = new ElmCompiler(baseConfig);
        });

        it('defaults to the public js folder', function () {
          expect(elmCompiler.elm_config.outputFolder).to.equal('test/public/folder/js');
        });
      });

      describe('when an outputFolder is specified', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(baseConfig));
          config.plugins.elmBrunch.outputFolder = 'test/output/folder'
          elmCompiler = new ElmCompiler(config);
        });

        it('uses the specified outputFolder', function () {
          expect(elmCompiler.elm_config.outputFolder).to.equal('test/output/folder');
        });
      });
    });

    describe('mainModules', function () {
      describe('when no mainModules are specified', function () {
        beforeEach(function () {
          elmCompiler = new ElmCompiler(baseConfig);
        });

        it('is undefined', function () {
          expect(elmCompiler.elm_config.mainModules).to.be.undefined;
        });
      });

      describe('when one mainModule is specified', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(baseConfig));
          config.plugins.elmBrunch.mainModules = ['Test.elm']
          elmCompiler = new ElmCompiler(config);
        });

        it('provides the specified mainModule', function () {
          expect(elmCompiler.elm_config.mainModules.length).to.equal(1);
          expect(elmCompiler.elm_config.mainModules).to.include('Test.elm');
        });
      });

      describe('when more than one mainModule is specified', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(baseConfig));
          config.plugins.elmBrunch.mainModules = ['Test1.elm', 'Test2.elm']
          elmCompiler = new ElmCompiler(config);
        });

        it('provides the specified mainModule', function () {
          expect(elmCompiler.elm_config.mainModules.length).to.equal(2);
          expect(elmCompiler.elm_config.mainModules).to.include('Test1.elm');
          expect(elmCompiler.elm_config.mainModules).to.include('Test2.elm');
        });
      });
    });

    describe('elmFolder', function () {
      describe('when an elmFolder is not specified', function () {
        beforeEach(function () {
          elmCompiler = new ElmCompiler(baseConfig);
        });

        it('defaults to null', function () {
          expect(elmCompiler.elm_config.elmFolder).to.be.null;
        });
      });

      describe('when an elmFolder is specified', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(baseConfig));
          config.plugins.elmBrunch.elmFolder = 'test/elm/folder'
          elmCompiler = new ElmCompiler(config);
        });

        it('uses the specified elmFolder', function () {
          expect(elmCompiler.elm_config.elmFolder).to.equal('test/elm/folder');
        });
      });
      describe('when an elmFolder has Windows syntax', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(baseConfig));
          config.plugins.elmBrunch.elmFolder = 'test\\elm\\folder'
          elmCompiler = new ElmCompiler(config);
        });

        it('uses the specified elmFolder', function () {
          expect(elmCompiler.elm_config.elmFolder).to.equal('test\\elm\\folder');
        });
      });
    });


    describe('makeParameters', function () {
      describe('when no makeParameters are not specified', function () {
        beforeEach(function () {
          elmCompiler = new ElmCompiler(baseConfig);
        });

        it('defaults to an empty list', function () {
          expect(elmCompiler.elm_config.makeParameters).to.be.empty;
        });
      });

      describe('when some makeParameters are specified', function () {
        var makeParameters = ['--warn'];
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(baseConfig));
          config.plugins.elmBrunch.makeParameters = makeParameters;
          elmCompiler = new ElmCompiler(config);
        });

        it('uses the specified makeParameters', function () {
          expect(elmCompiler.elm_config.makeParameters).to.equal(makeParameters);
        });
      });
    });
  });



  describe('compiling Elm', function () {
    var childProcess = require('child_process')
      , sampleConfig;

    beforeEach(function () {
      execSync = sinon.stub(childProcess, 'execSync');

      sampleConfig = JSON.parse(JSON.stringify(baseConfig));
      sampleConfig.plugins.elmBrunch.outputFolder = 'test/output/folder';
      sampleConfig.plugins.elmBrunch.mainModules = ['Test.elm'];
    });

    afterEach(function () {
      execSync.restore();
    });

    describe('when an elm folder has not been given', function () {
      beforeEach(function () {
        config = JSON.parse(JSON.stringify(sampleConfig));
        elmCompiler = new ElmCompiler(config);
      });

      it('shells out to the `elm-make` command with a null cwd', function () {
        var content = '';
        elmCompiler.compile(content, 'File.elm', function(error, data) {
          expect(error).to.not.be.ok;
          expect(data).to.equal('');
        });
        elmCompiler.compile(content, 'File.elm', function(error) {
          expect(error).to.not.be.ok;
        });
        expected = 'elm-make --yes --output test/output/folder/test.js Test.elm';
        expect(childProcess.execSync).to.have.been.calledWith(expected, {cwd: null});
      });
    });

    describe('when an elm folder has been given', function () {
      beforeEach(function () {
        config = JSON.parse(JSON.stringify(sampleConfig));
        config.plugins.elmBrunch.elmFolder = 'test/elm/folder';
        elmCompiler = new ElmCompiler(config);
      });

      it('shells out to the `elm-make` command with the specified elm folder as the cwd', function () {
        var content = '';
        elmCompiler.compile(content, 'File.elm', function(error) {
          expect(error).to.not.be.ok;
        });
        elmCompiler.compile(content, 'File.elm', function(error) {
          expect(error).to.not.be.ok;
        });
        expected = 'elm-make --yes --output test/output/folder/test.js Test.elm';
        expect(childProcess.execSync).to.have.been.calledWith(expected, {cwd: 'test/elm/folder'});
      });

      it('normalises the brunch file path to the elmFolder path', function () {
        var content = '';
        elmCompiler.compile(content, 'test/elm/folder/Test.elm', function(error) {
          expect(error).to.not.be.ok;
        });
        expected = 'elm-make --yes --output test/output/folder/test.js Test.elm';
        expect(childProcess.execSync).to.have.been.calledWith(expected, {cwd: 'test/elm/folder'});
      });

    });

    describe('the initial run', function () {
      describe('when main module is specified', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(sampleConfig));
          elmCompiler = new ElmCompiler(config);
        });

        it('should skip non main modules', function () {
          var content = '';
          elmCompiler.compile(content, 'File.elm', function(error, data) {
            expect(error).to.not.be.ok;
            expect(data).to.equal('');
          });
          expected = '';
          expect(childProcess.execSync).to.not.have.been.called;
        });

        it('should compile main modules', function () {
          var content = '';
          elmCompiler.compile(content, 'Test.elm', function(error) {
            expect(error).to.not.be.ok;
          });
          expected = 'elm-make --yes --output test/output/folder/test.js Test.elm';
          expect(childProcess.execSync).to.have.been.calledWith(expected, {cwd: null});
        });
      });

      describe('when no main module is specified', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(sampleConfig));
          delete config.plugins.elmBrunch.mainModules;
          elmCompiler = new ElmCompiler(config);
        });

        it('should compile all modules', function () {
          var content = '';
          elmCompiler.compile(content, 'Test.elm', function(error) {
            expect(error).to.not.be.ok;
          });
          expected = 'elm-make --yes --output test/output/folder/test.js Test.elm';
          expect(childProcess.execSync).to.have.been.calledWith(expected, {cwd: null});
        });
      });

      describe('when more than one mainModule is specified', function () {
        beforeEach(function () {
          config = JSON.parse(JSON.stringify(baseConfig));
          config.plugins.elmBrunch.outputFolder = 'test/output/folder';
          config.plugins.elmBrunch.mainModules = ['Test1.elm', 'Test2.elm'];
          config.plugins.elmBrunch.outputFile = 'test.js';
          elmCompiler = new ElmCompiler(config);
        });
        it('should compile all modules into a single file', function () {
          var content = '';
          elmCompiler.compile(content, 'Test1.elm', function(error) {
            expect(error).to.not.be.ok;
          });
          expected = 'elm-make --yes --output test/output/folder/test.js Test1.elm Test2.elm';
          expect(childProcess.execSync).to.have.been.calledWith(expected, {cwd: null});
        });
      });
    });
  });
});
