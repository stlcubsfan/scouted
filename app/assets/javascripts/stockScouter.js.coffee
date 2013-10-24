stockScouterApp = angular.module('stockScouterApp', ['ngResource', 'ngRoute'])

stockScouterApp.config ($routeProvider) ->
  $routeProvider.when '/', templateUrl: '/templates/stockList.html', controller: 'StockScouterListController'

$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])