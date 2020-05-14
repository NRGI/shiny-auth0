var express = require('express');
var passport = require('passport');
var httpProxy = require('http-proxy');
var ensureLoggedIn = require('connect-ensure-login').ensureLoggedIn()
var router = express.Router();

var proxy = httpProxy.createProxyServer({
  ws:true,
  target: {
      host: process.env.SHINY_HOST,
      port: process.env.SHINY_PORT
    }
});

var server = require('http').createServer(function(req, res) {
  proxy.web(req, res, {
    target: options[req.headers.host]
  },function(e){
    log_error(e,req);
  });
})


proxy.on('error', function(e) {
  console.log('Error connecting');
  console.log(e);
});

var setIfExists = function(proxyReq, header, value){
  if(value){
      proxyReq.setHeader(header, encodeURIComponent(value));
  }
}

proxy.on('proxyReq', function(proxyReq, req, res, options) {
  setIfExists(proxyReq, 'x-auth0-nickname', req.user._json.nickname);
  setIfExists(proxyReq, 'x-auth0-user_id', req.user._json.user_id);
  setIfExists(proxyReq, 'x-auth0-email', req.user._json.email);
  setIfExists(proxyReq, 'x-auth0-name', req.user._json.name);
  setIfExists(proxyReq, 'x-auth0-picture', req.user._json.picture);
  setIfExists(proxyReq, 'x-auth0-locale', req.user._json.locale);
});

//
// Listen to the `upgrade` event and proxy the
// WebSocket requests as well.
//
server.on('upgrade', function (req, socket, head) {
  console.log("proxying upgrade request", req.url);
  proxy.ws(req, socket, head);
});

proxy.on('error', function (req, socket, head) {
  console.log("error!!!")
});

/* Proxy all requests */
router.all(/.*/, ensureLoggedIn, function(req, res, next) {
  proxy.web(req, res);
});

module.exports = router;
