# native-notifier

Use native system notifications for MacOS, Win & Linux. No bullshit & no Growl.

```javascript
const notify = require('native-notifier');
notify({
  app: 'Loggy',
  icon: `${__dirname}/loggy.png`,
  message: 'TypeError: stack is shown',
  title: 'Loggy error'
});
```

![Screen Shot 2013-04-21 at 03 26 41](https://cloud.githubusercontent.com/assets/574696/22355836/d5a57152-e435-11e6-8b22-6aca8b4e79b1.png)

# License

MIT
