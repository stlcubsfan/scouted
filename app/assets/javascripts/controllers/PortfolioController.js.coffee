angular.module('stockScouterApp').controller "PortfolioController", ($rootScope, $scope, PortfolioService, StockScouterList, CurrentStockInfo) ->

  @scouterService = new StockScouterList()

  topStocks = []
  symList = []
  @scouterService.raw().query (data) ->
    @portfolioService = new PortfolioService()
    @currentStockInfoService = new CurrentStockInfo()
    topStocks = data
    $scope.portfolioStocks = @portfolioService.all()
    symList = topStocks.map (n) ->
      return n["sym"]
    $scope.portfolioStocks.forEach (n) ->
      n['inList'] = symList.some n.sym
      @currentStockInfoService.raw().get {sym: n.sym}, (data) ->
        n['currentPrice'] = data.price
        n['rating'] = data.rating
        n['gainLoss'] = makingMoney n['price'], n['currentPrice']

  makingMoney = (price, currentPrice) ->
    val = Math.round (((currentPrice - price) / currentPrice) * 10000)
    val / 100



