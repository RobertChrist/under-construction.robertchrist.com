const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'source-map',
  devServer: {
    static: './dist',
    open: {
      app: {
        name: 'Google Chrome'
      }
    },
    watchFiles: ['./src/scripts', './dist/css', './dist/images', './src/index.html']
  },
});