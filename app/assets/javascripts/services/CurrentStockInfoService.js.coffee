angular.module('stockScouterApp').factory 'CurrentStockInfo', ($resource, $http) ->
  class CurrentStockInfo
    constructor: (errorHandler) ->
      @service = $resource('/api/stock_scouter/:sym/currentStockInfo', {sym:'@id'})
      @errorHandler = errorHandler
    raw: ->
      @service