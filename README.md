 [![Build Status](https://travis-ci.org/ismith/elevator_alerts.svg?branch=master)](https://travis-ci.org/ismith/elevator_alerts)
 
Setup should be done via the console script, either by hand or scripted.

Periodically, you may wish to check for any newly-discovered Elevator records.
(That is, elevators reported by the API, but which have not been associated with
a station.)  To do this, run `Models::Elevator.stationless` from within the
console.

To get a local copy of heroku config:
```
heroku config -s >> .env
```

Heroku addons:
heroku addons:create heroku-postgres:hobby-dev # 7k records
heroku addons:create sendgrid:starter # 400/day
heroku addons:create rollbar:free # 3000/mo, 30 days retention
heroku addons:create keen:developer
# heroku addons:create deployhooks:http [redacted] # you can get this from https://rollbar.com/elevatoralerts/elevatoralerts/deploys/

Note:
Not using heroku scheduler because it can only run hourly or every 10 minutes,
and I'm aiming for ~1/minute.

Possible future TODOs:
[ ] Add unsubscribe link - Sendgrid makes this really simple, but I'm not sure
  if there's a way to re-subscribe

HOWTO:
- log to stdout instead of sending email: set NO_EMAIL env var
- If ALLOWED_USERS='*', then anyone can register.  Otherwise, it should be a
  comma-separated list of email addresses