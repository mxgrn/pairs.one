# WebSockets

Web sockets make it cheaper to talk to your servers.


## Benefits

Connecting to a server takes some time, so with web sockets, you make that
connection once and then keep using. The major benefits of this are:

  1. It is faster to send messages. No need to do a bunch of work for every
  single message.

  2. The server can push messages to you. With normal HTTP you would have to
  keep *asking* for changes, but a web socket, the server can talk to you
  whenever it wants. This means there is less unnecessary network traffic.


## Learn

The best way to learn how to use this library is to read [guide.elm-lang.org](http://guide.elm-lang.org/), particularly the section on [The Elm Architecture](http://guide.elm-lang.org/architecture/index.html).

