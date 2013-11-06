stockScouterApp = angular.module('stockScouterApp', ['ngResource', 'ngRoute', 'ui.router']).run(['$rootScope', '$state', '$stateParams', ($rootScope, $state, $stateParams) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
])

stockScouterApp.config (['$stateProvider', '$urlRouterProvider', '$httpProvider',  ($stateProvider, $urlRouterProvider, $httpProvider) ->
  $urlRouterProvider.when "", "/"
  $stateProvider.state 'index', {
    url: "/",
    views: {
      "stockList": {
        templateUrl: "/templates/stockList.html",
        controller: "StockScouterListController"
      },
      "portfolio": {
        templateUrl: "/templates/portfolio.html",
        controller: "PortfolioController"
      }
    }
  }
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
  defaults = $httpProvider.defaults.headers
  defaults.patch = defaults.patch || {}
  defaults.patch['Content-Type'] = 'application/json'
])

$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()