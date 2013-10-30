angular.module('stockScouterApp').controller "StockScouterListController", ($rootScope, $scope, StockScouterList) ->

  @listService = new StockScouterList()
  $scope.list = @listService.all()
  $rootScope.$stockList = $scope.list
