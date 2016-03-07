_ = require 'lodash'
React = require 'react'

{DOM} = React

displayArray =
  cols: 6
  rows: 2

module.exports = ConfigurationClass = React.createClass
  render: ->
    {displays} = @props.configuration

    displayWidth = 30
    displayHeight = 6

    DOM.div null,
      DOM.div null,
        DOM.h2 null, @props.configuration.name
      DOM.div
        style:
          margin: '1em 0'
          border: 'solid 1px #999'
          backgroundColor: 'rgba(0, 0, 0, 0.7)'
          borderRadius: '0.7em'
          width: "#{displayWidth}em"
          height: "#{displayHeight}em"
      ,
        DOM.div
          style:
            position: 'absolute'
        ,
          _.map displays, (display, displayIndex) =>
            DOM.div
              key: displayIndex
              style:
                position: 'absolute'
                left: "#{0.1 + display.x / displayArray.cols * displayWidth}em"
                top: "#{0.1 + display.y / displayArray.rows * displayHeight}em"
                width: "#{-0.2 + display.width / displayArray.cols * displayWidth}em"
                height: "#{-0.2 + display.height / displayArray.rows * displayHeight}em"
                # border: 'solid 1px #bbb'
                borderRadius: '0.5em'
                backgroundColor: 'rgba(100, 255, 100, 0.4)'
            , ' '

      DOM.p null,
        DOM.input
          type: 'button'
          value: 'select' + (if @props.selected then 'ed' else '')
          disabled: @props.selected
          onClick: @props.onSelect

@Configuration = React.createFactory ConfigurationClass

module.exports
