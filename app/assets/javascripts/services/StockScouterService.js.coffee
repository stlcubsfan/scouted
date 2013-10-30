angular.module('stockScouterApp').factory 'StockScouterList', ($resource, $http) ->
  class StockScouterList
    constructor: (errorHandler) ->
      @service = $resource('/api/stock_scouter')
      @errorHandler = errorHandler

      defaults = $http.defaults.headers

    all: ->
      @service.query((-> null), @errorHandler)
    raw: ->
      @service

