stockScouterApp = angular.module('stockScouterApp', ['ngResource', 'ngRoute', 'ui.router']).run(['$rootScope', '$state', '$stateParams', ($rootScope, $state, $stateParams) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
])

stockScouterApp.config (['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
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
])

$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()