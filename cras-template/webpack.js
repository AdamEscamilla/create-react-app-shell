const path = require('path');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const webpack = require('webpack')
const dotenv = require('dotenv')

module.exports = env => {
    console.log("development: ", env.development)

    return {
        //devtool: 'inline-source-map',  /*** DEBUG ***/
        entry: './src/index.js',
        output: {
            path: __dirname + '/dist',
            publicPath: '/',
            filename: 'bundle.js'
        },
        devServer: {
            contentBase: './public',
            publicPath: '/dist/',
            port: 3000,
            host: '0.0.0.0',
            compress: true,
            hot: false,
            inline: false,
            liveReload: false,
            injectClient: false,
            hotOnly: false,
            https: false,
            sockPort: 443,
            historyApiFallback: true,
            disableHostCheck: true,
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
                "Access-Control-Allow-Headers": "X-Requested-With, content-type, Authorization"
            }
        },
        module: {
            rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                loader: 'babel-loader',
                options: {
                    presets: [
                        '@babel/preset-env',
                        '@babel/preset-react'
                    ],
                    plugins: [
                        '@babel/plugin-proposal-class-properties'
                    ]
                }
            },
            {
                test: /\.css$/,
                use: [
                {
                    loader: MiniCssExtractPlugin.loader,
                    options: {
                        publicPath: ''
                    }
                },
                {
                    loader: "css-loader"
                }]
            },
            {
                test: /\.(png|jpe?g|gif|svg)$/,
                use: [
                {
                    loader: 'file-loader',
                    options: {
                        outputPath: 'images',
                        esModule: false
                    }
                }],
                type: 'javascript/auto'
            }]
        },
        plugins: [
                new MiniCssExtractPlugin({
                        filename: "bundle.css"
                }),
                new webpack.DefinePlugin({
                       'process.env': JSON.stringify(dotenv.config().parsed) // it will automatically pick up key values from .env file
                })
        ],
        mode: 'development'
    }
};
