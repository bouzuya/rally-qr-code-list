"use strict";

exports.toDataUrlImpl = function (errorCorrectionLevel) {
  return function (text) {
    return function () {
      var toDataURL = require('qrcode').toDataURL;
      var options = { errorCorrectionLevel: errorCorrectionLevel };
      return toDataURL(text, options);
    };
  };
};
