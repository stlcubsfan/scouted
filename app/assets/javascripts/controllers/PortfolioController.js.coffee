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
        n['advice'] = getAdvice(n)

  makingMoney = (price, currentPrice) ->
    val = ((currentPrice - price) / currentPrice) * 100

  getAdvice = (stock) ->
    advice = {}
    val = ""
    msg = "Hold"
    if stock.rating <= 7 || (!stock.inList && stock.rating <=8) || (!stock.inList && stock.gainLoss < 0)
      val = "error"
      msg = "Sell Immediately"
    else if !stock.inList
      if (stock.rating == 9 && stock.gainLoss > 5) || (stock.rating == 10 && stock.gainLoss > 10)
        val = "info"
        msg = "Place trailing sale of 5%"
    else if stock.inList
      if stock.rating == 8
        if stock.gainLoss > 10
          val = "info"
          msg = "Place trailing sale of 5%"
        if stock.gainLoss > 15
          val = "success"
          msg = "Place trailing sale of 10%"
      else if stock.rating == 9
        if stock.gainLoss > 15
          val = "info"
          msg = "Place trailing sale of 5%"
        if stock.gainLoss > 20
          val = "success"
          msg = "Place trailing sale of 10%"
      else if stock.rating == 10 && stock.gainLoss > 25
        val = "success"
        msg = "Place trailing sale of 10%"
    advice["val"] = val
    advice["msg"] = msg
    advice



