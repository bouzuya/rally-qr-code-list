# rally-qr-code-list

## How to run

```
$ # set env (see: _envrc)
$ npm i
$ npm run build
$ npm start
```

Or

Heroku & Docker

```
$ heroku create
$ heroku container:login
$ heroku container:push web
$ heroku container:release web
$ # set env (e.g. `heroku config:set ASSETS_BASE_URL=`)
```
