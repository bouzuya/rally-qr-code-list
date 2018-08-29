"use strict";

exports.hydrateImpl = function (selector) {
  var React = require('react');
  var ReactDOM = require('react-dom');
  return function (reactClass) {
    return function () {
      ReactDOM.hydrate(
        React.createElement(reactClass),
        document.querySelector(selector)
      );
    };
  };
};
