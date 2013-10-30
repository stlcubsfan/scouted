angular.module('stockScouterApp').factory 'PortfolioService', ($resource, $http) ->
  class PortfolioService
    constructor: (errorHandler) ->
      @errorHandler = errorHandler

    all: ->
      [{sym: "ASR", price: 50.79},{sym:"AAPL", price:494.00}, {sym:"TIVO", price: 5.00}]