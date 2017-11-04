# elm-brunch

[Brunch](http://brunch.io) plugin to compile Elm code


## Quickstart

First, [install Elm](https://guide.elm-lang.org/install.html).

Then, install elm-brunch:

```
npm install --save-dev elm-brunch
```

Update the `watched` configuration in your brunch-config.js, e.g.:

```
paths: {
  watched: ["css", "js", "elm"]
  ...
```


## Configuration

```
  // Configure your plugins in brunch-config.js (or .coffee)
    plugins: {
      ...

      elmBrunch: {
        // (required) Set to the elm file(s) containing your "main" function `elm make` 
        //            handles all elm dependencies relative to `elmFolder`
        mainModules: ['source/path/YourMainModule.elm'],

        // (optional) Set to path where `elm-make` is located, relative to `elmFolder`
        executablePath: '../../node_modules/elm/binwrappers',

        // (optional) Set to path where elm-package.json is located, defaults to project root
        //            if your elm files are not in /app then make sure to configure 
        //            paths.watched in main brunch config
        elmFolder: 'path/to/elm-files',

        // (optional) Defaults to 'js/' folder in paths.public
        // relative to `elmFolder`
        outputFolder: 'some/path/',

        // (optional) If specified, all mainModules will be compiled to a single file 
        //            This is merged with outputFolder.
        outputFile: 'elm.js',

        // (optional) add some parameters that are passed to elm-make
        makeParameters: ['--warn']
      }
   }

```

The output filename is the lowercase version of the main module name:
```
YourMainModule.elm => outputFolder/yourmainmodule.js
```

Note: You should update the "source-directories" property in the elm-package.json file if you want to compile multi-file elm projects.
Then configure elm-brunch:


## Examples

The following repos are examples of elm-brunch configuration:
- https://github.com/joedski/brunch-with-elm/blob/master/brunch-config.coffee
- https://github.com/madsflensted/dots/blob/master/brunch-config.js
- https://github.com/ivanoats/Bingo/blob/master/brunch-config.js
