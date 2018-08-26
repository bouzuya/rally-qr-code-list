const path = require('path');
const webpack = require('webpack');

module.exports = {
  devServer: {
    contentBase: path.join(__dirname, 'dist'),
    compress: true,
    headers: {
      'Access-Control-Allow-Origin': '*'
    },
    host: '0.0.0.0',
    // hot: true,
    port: 8081,
  },
  entry: {
    app: [
      'webpack-dev-server/client?http://localhost:8081',
      'webpack/hot/dev-server',
      path.resolve(__dirname, 'client.js'),
    ]
  },
  mode: 'development',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'script/index.js'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ]
};
