const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

let outputDir = path.join(__dirname, "build");

module.exports = {
  entry: './lib/es6/src/Index.bs.js',
  // If you ever want to use webpack during development, change 'production'
  // to 'development' as per webpack documentation. Again, you don't have to
  // use webpack or any other bundler during development! Recheck README if
  // you didn't know this
  mode: 'development',
  output: {
    path: outputDir,
    publicPath: '/',
    filename: '[name].[chunkhash:4].js'.toLowerCase(),
    chunkFilename: '[name].[chunkhash:4].chunk.js'.toLowerCase()
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'index.html',
      inject: true,
    })
  ],
  devServer: {
    stats: 'normal',
    port: process.env.PORT || 8000,
    compress: false,
    contentBase: outputDir,
    historyApiFallback: true
  }
};