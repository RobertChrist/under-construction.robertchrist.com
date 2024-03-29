const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ESLintPlugin = require('eslint-webpack-plugin');
// Load .env into webpack for use in scripts.
const Dotenv = require('dotenv-webpack');
// Load .env for use in this file.
require('dotenv').config();

module.exports = {
  entry: './src/scripts/index.js',
  plugins: [
    new Dotenv(),
    new ESLintPlugin({}),
    new HtmlWebpackPlugin({
      hash: true,
      template: './src/index.html',
      recaptchaScript: `${process.env.GRECAPTCHA_API_KEY}`
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