"use strict";

function getStorage() {
  var CookieStorage = require('cookie-storage').CookieStorage;
  var twoWeeksInMilliSeconds = 14 * 24 * 60 * 60 * 1000;
  return new CookieStorage({
    path: '/',
    expires: new Date(new Date().getTime() + twoWeeksInMilliSeconds),
    secure: false
  });
}

exports.loadTokenImpl = function () {
  var storage = getStorage();
  return storage.getItem('rally-qr-code-list-token');
};

exports.removeTokenImpl = function () {
  var storage = getStorage();
  return storage.removeItem('rally-qr-code-list-token');
};

exports.saveTokenImpl = function (value) {
  return function () {
    var storage = getStorage();
    return storage.setItem('rally-qr-code-list-token', value);
  };
};
