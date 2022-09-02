const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ESLintPlugin = require('eslint-webpack-plugin');
const Dotenv = require('dotenv-webpack');

module.exports = {
  entry: './src/scripts/index.js',
  plugins: [
    new Dotenv(),
    new ESLintPlugin({}),
    new HtmlWebpackPlugin({
      hash: true,
      template: './src/index.html'
    })
  ],
  module: {
    rules: [{
      test: /\.m?js$/,
      exclude: /node_modules/,
      use: {
        loader: 'babel-loader',
        options: {
          presets: ['@babel/preset-env'],
          plugins: ['@babel/plugin-proposal-object-rest-spread', "@babel/plugin-transform-runtime"],
          cacheDirectory: true
        }
      }
    }]
  },
  output: {
    filename: 'scripts/index.[contenthash].js',
    path: path.resolve(__dirname, 'dist'),
  },
  optimization: {
    moduleIds: 'deterministic'
  }
};