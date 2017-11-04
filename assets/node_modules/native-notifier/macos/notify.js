'use strict';
/* eslint-env applescript */
/* eslint-disable new-cap */

var showNode = function() {
  var term = Application('Terminal');
  if (!term.running()) return;

  var windows = term.windows();
  var win, tabs, tab;
  for (var i = 0; i < windows.length; i++) {
    win = windows[i];
    tabs = win.tabs();
    for (var j = 0; j < tabs.length; j++) {
      tab = tabs[j];
      if (!tab.processes().includes('node')) continue;

      tab.selected = true;
      win.frontmost = true;
      term.activate();

      return;
    }
  }
};

var app = Application.currentApplication();
app.includeStandardAdditions = true;

var withTitle = app.systemAttribute('TITLE');
var message = app.systemAttribute('MESSAGE');

if (withTitle || message) {
  app.displayNotification(message, {withTitle: withTitle});
} else {
  showNode();
}
