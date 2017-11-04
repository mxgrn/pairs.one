# tag-shell

Use ES6 template tags for your node.js shell commands.

```javascript
const sh = require('tag-shell');
const opts = {app: 'App', icon: 'icon.png'};
sh.async`notify-send -a ${opts.app}
  -i ${opts.icon}
`;
```

## License

MIT
