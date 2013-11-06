angular.module('stockScouterApp').factory 'PortfolioService', ($resource, $http) ->
  $resource('/api/positions/:id', {id: '@id'}, {update: {method: 'PATCH'}})