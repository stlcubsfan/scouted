angular.module('stockScouterApp').controller "PortfolioController", ($rootScope, $scope, PortfolioService, StockScouterList) ->

  @scouterService = new StockScouterList()

  topStocks = []
  symList = []
  @scouterService.raw().query (data) ->
    @portfolioService = new PortfolioService()
    topStocks = data
    $scope.portfolioStocks = @portfolioService.all()
    symList = topStocks.map (n) ->
      return n["sym"]
    $scope.portfolioStocks.forEach (n) ->
      n['inList'] = symList.some n.sym
  $scope.makingMoney = (sym, price) ->
    matchedStock = topStocks.find {'sym': sym}
    if matchedStock
      val = Math.round (((matchedStock.price - price) / matchedStock.price) * 10000)
      val / 100
    else
      0


