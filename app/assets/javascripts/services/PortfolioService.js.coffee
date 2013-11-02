angular.module('stockScouterApp').factory 'PortfolioService', ($resource, $http) ->
  $resource('/api/positions')