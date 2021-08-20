const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

let outputDir = path.join(__dirname, "build");

module.exports = {
  entry: {
    'index': './lib/es6/src/Index.bs.js',
    'style': './public/css/index.scss'
  },
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
    }),
    new MiniCssExtractPlugin({
      filename: '[name].[hash:4].css',
      chunkFilename: '[id].[hash:4].css'
    }),
  ],
  module: {
    rules: [
      {
        test: /\.(eot|woff|woff2|ttf)$/,
        loader: "url-loader"
      },
      {
        test: /\.(jpe?g|png|gif|svg|ico)$/,
        use: [{
          loader: 'file-loader',
          options: {
            name: '[path][name]-[hash:4].[ext]',
          },
        },]
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader" // translates CSS into CommonJS
          },
          {
            loader: "sass-loader" // compiles Sass to CSS
          }
        ]
      }
    ]
  },
  devServer: {
    stats: 'normal',
    port: process.env.PORT || 8000,
    compress: false,
    contentBase: outputDir,
    historyApiFallback: true
  }
};
