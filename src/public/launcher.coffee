path = require 'path'

_ = require 'lodash'
electron = require 'electron'
React = require 'react'
ReactDOM = require 'react-dom'
request = require 'request'

ipcRenderer = electron.ipcRenderer
{DOM} = React

App = React.createFactory React.createClass
  getInitialState: ->
    configurations: @props.configurations ? []
    configurationId: 0

  componentDidMount: ->
    @refresh()

  refresh: ->
    return unless @isMounted()
    url = "http://fact0ry.shaler.me/configurations.json"
    request url, (err, httpWhatever, body) =>
      return unless @isMounted()
      if err
        console.log 'error', err
        return
      return unless body
      try
        obj = JSON.parse body
      catch ex
        console.log 'error', ex, body
        return
      @setState obj

  selectConfiguration: (id) ->
    (e) =>
      e.preventDefault()
      @setState
        configurationId: parseInt id

  launch: (e) ->
    e.preventDefault()
    e.stopPropagation()
    configuration = @state.configurations[@state.configurationId]
    @props.onLaunch configuration

  render: ->
    DOM.div null,
      DOM.h1 null, 'Command Center'
      DOM.div null,
        _.map @state.configurations, (c, index) =>
          Configuration
            key: index
            configuration: c
            selected: index == @state.configurationId
            onSelect: @selectConfiguration index
            onLaunch: @launch
      # DOM.button
      #   onClick: @launch
      # , 'launch'

el = document.getElementById 'launcher'
app = new App
  onLaunch: (data) ->
    ipcRenderer.send 'launch', data
  configurations: []

ReactDOM.render app, el
