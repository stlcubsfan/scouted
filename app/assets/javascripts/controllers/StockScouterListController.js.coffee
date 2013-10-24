angular.module('stockScouterApp').controller "StockScouterListController", ($scope, StockScouterList) ->

  $scope.init = () ->

    @listService = new StockScouterList()
    $scope.list = @listService.all()

  $scope.crap = "crap"