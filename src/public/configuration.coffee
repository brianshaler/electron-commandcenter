crypto = require 'crypto'

_ = require 'lodash'
React = require 'react'

getCacheImagePath = require '../getCacheImagePath'

{DOM} = React

displayArray =
  cols: 6
  rows: 2

module.exports = ConfigurationClass = React.createClass
  render: ->
    {displays} = @props.configuration

    displayWidth = 30
    displayHeight = 6
    borderRadius = 0.7

    if !@props.selected
      displayWidth *= 0.5
      displayHeight *= 0.5
      borderRadius *= 0.5

    DOM.div
      onClick: if @props.selected
        @props.onLaunch
      else
        @props.onSelect
    ,
      DOM.div null,
        DOM.h2 null, @props.configuration.name
      DOM.div
        className: 'animate-all'
        style:
          margin: '1em 0'
          border: 'solid 1px #999'
          backgroundColor: 'rgba(0, 0, 0, 0.7)'
          borderRadius: "#{borderRadius}em"
          width: "#{displayWidth}em"
          height: "#{displayHeight}em"
      ,
        DOM.div
          style:
            position: 'absolute'
        ,
          _.map displays, (display, displayIndex) =>
            w = "#{-0.2 + display.width / displayArray.cols * displayWidth}em"
            h = "#{-0.2 + display.height / displayArray.rows * displayHeight}em"

            DOM.div
              key: displayIndex
              className: 'animate-all'
              style:
                position: 'absolute'
                left: "#{0.1 + display.x / displayArray.cols * displayWidth}em"
                top: "#{0.1 + display.y / displayArray.rows * displayHeight}em"
                width: w
                height: h
                # border: 'solid 1px #bbb'
                borderRadius: "#{borderRadius * 0.8}em"
                backgroundColor: 'rgba(100, 255, 100, 0.4)'
                overflow: 'hidden'
                backgroundImage: "url(#{getCacheImagePath.sync display.url, display.width, display.height})"
                backgroundSize: "#{w} #{h}"
            , ' '
        if @props.selected
          DOM.div
            style:
              position: 'absolute'
          ,
            DOM.input
              type: 'button'
              value: 'launch'
              style:
                position: 'absolute'
                left: "#{displayWidth * 0.5}em"
                top: "#{displayHeight * 0.5}em"
              onClick: @props.onLaunch
        else
          null

@Configuration = React.createFactory ConfigurationClass

module.exports
