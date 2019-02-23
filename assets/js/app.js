// Some native code to support our Elm app (including the ports)
$(function(){
  var idKey = 'pairs-one-player-id',
    nameKey = 'pairs-one-player',
    settingsKey = 'pairs-one-settings',
    seenNewsIdKey = "pairs-one-last-seen-news-id",
    playerId = localStorage.getItem(idKey),
    locale = $("html").attr("lang"),
    elm,
    playerName = localStorage.getItem(nameKey),
    s4 = function() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    },
    base64ToArrayBuffer = function(base64) {
        var binary_string =  window.atob(base64);
        var len = binary_string.length;
        var bytes = new Uint8Array( len );
        for (var i = 0; i < len; i++)        {
            bytes[i] = binary_string.charCodeAt(i);
        }
        return bytes;
    },
    arrayBufferToBase64 = function( buffer ) {
        var binary = '';
        var bytes = new Uint8Array( buffer );
        var len = bytes.byteLength;
        for (var i = 0; i < len; i++) {
            binary += String.fromCharCode( bytes[ i ] );
        }
        return window.btoa( binary );
    },
    newsBar = $(".news-bar"),
    seenNewsId = JSON.parse(localStorage.getItem(seenNewsIdKey) || 0),
    currentNewsId = newsBar.data("news-id");

  if (!playerId) {
    var uuid = s4() + s4() + s4() + s4();
    localStorage.setItem(idKey, uuid);
    playerId = uuid;
  }

  newsBar.children(".close").on("click", function() {
    newsBar.hide();
    localStorage.setItem(seenNewsIdKey, currentNewsId);
  });

  if (seenNewsId < currentNewsId) {
    newsBar.show();
  }

  $("#elm-game").each(
    function(i, el){
      var themes = $(el).data('themes');

      elm = Elm.Game.embed(el, {
        id: "" + $(el).data('id'), // because sometimes it comes as an number
        playerId: playerId,
        playerName: playerName || "",
        host: location.host,
        isSsl: location.protocol == "https:",
        themes: themes,
        locale: locale
      });

      // Elm ports
      elm.ports.playAudio.subscribe(function(audio){
        var audio = new Audio("/sounds/" + audio + ".mp3");
        audio.play();
      });

      elm.ports.compressAndSendGame.subscribe(function(game){
        var compressed = arrayBufferToBase64(
          LZString.compressToUint8Array(
            JSON.stringify(game)
          )
        );
        elm.ports.onSendCompressedGame.send(compressed);
      });

      elm.ports.decompressAndUpdateGame.subscribe(function(params){
        var game = JSON.parse(
          LZString.decompressFromUint8Array(
            base64ToArrayBuffer(params.game)
          )
        );
        elm.ports.onGameUpdate.send(game);
      });

      elm.ports.focus.subscribe( function(el){
        $(el).select();
      });

      elm.ports.copyUrl.subscribe( function(el){
        $(el).select();
        try {
          succeeded = document.execCommand("copy");
        } catch (err) {};
      });

      elm.ports.storeNameLocally.subscribe(function(name){
        localStorage.setItem('pairs-one-player', name);
      });

      window.addEventListener("focus", function(event){
        elm.ports.onFocusChange.send(true);
      }, true);

      window.addEventListener("blur", function(event){
        elm.ports.onFocusChange.send(false);
      }, true);
    }
  )

  $("#player-data input").attr("value", playerName);

  $("select#language").change( function(e){
    var lang = $(e.target).val();
    window.location = location.pathname.replace(/\/[a-z-]+\//, "/"+ lang +"/");
  });

  // GameList

  $(".elm-game-list").each(
    function(i, el){
      var themes = $(el).data('themes');
      elm = Elm.GameList.embed(el, {
        host: location.host,
        locale: $("html").attr("lang")
      });
    }
  );

  // GameSelector

  $(".elm-game-selector").each(
    function(i, el){
      var defaultSettings = {
        theme: "eighties",
        size: 6,
        players: 2,
        visibility: "public"
      },
        settings = JSON.parse(localStorage.getItem(settingsKey) || JSON.stringify(defaultSettings));

      elm = Elm.GameSettings.embed(el, {
        csrf: $(el).data("csrf"),
        locale: $("html").attr("lang"),
        themes: $(el).data("themes"),
        theme: settings.theme,
        size: settings.size,
        players: settings.players,
        visibility: settings.visibility
      });

      elm.ports.saveSettingsToLocalStorage.subscribe(function(params){
        localStorage.setItem(settingsKey, JSON.stringify(params));
      });
    }
  );

  // Let Elm render first, then show everything together
  setTimeout(function(){ $("#main").addClass("visible") }, 0);
});
