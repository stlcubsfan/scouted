angular.module('stockScouterApp').controller "PortfolioController", ($rootScope, $scope, PortfolioService, StockScouterList, CurrentStockInfo) ->

  @scouterService = new StockScouterList()
  $scope.portfolioStocks = []
  topStocks = []
  symList = []
  @scouterService.raw().query (data) ->
    @currentStockInfoService = new CurrentStockInfo()
    topStocks = data
    PortfolioService.query {style: "open"}, (data) ->
      $scope.portfolioStocks = data
      symList = topStocks.map (n) ->
        return n["sym"]
      $scope.portfolioStocks.forEach (n) ->
        n['inList'] = symList.some n.symbol
        @currentStockInfoService.raw().get {sym: n.symbol}, (data) ->
          n['currentPrice'] = data.price
          n['rating'] = data.rating
          n['gainLoss'] = makingMoney n['purchase_price'], n['currentPrice']
          n['advice'] = getAdvice(n)
  addPosition = ->
    newPos = new PortfolioService({symbol: $scope.stockSymbol});
    newPos.purchase_price = $scope.pricePaid
    newPos.purchase_date = $scope.datePurchased
    newPos.shares = $scope.sharesPurchased
    newPos.$save (pos, stat) ->
      @currentStockInfoService.raw().get {sym: pos.symbol}, (data) ->
        pos['currentPrice'] = data.price
        pos['rating'] = data.rating
        pos['gainLoss'] = makingMoney pos['purchase_price'], pos['currentPrice']
        pos['advice'] = getAdvice(pos)
      $scope.portfolioStocks.push(pos)
      $scope.symbol = ""
      $scope.datePurchased = ""
      $scope.pricePaid = ""
      $scope.sharesPurchased = ""
      $scope.showAddForm = false


  cancelAddPosition = ->
    alert("canceled add position")
    $scope.showAddForm = false

  $scope.submitAddPosition = addPosition
  $scope.cancelAddPosition = cancelAddPosition

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



