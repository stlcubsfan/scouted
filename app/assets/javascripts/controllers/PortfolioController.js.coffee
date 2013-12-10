angular.module('stockScouterApp').controller "PortfolioController", ($rootScope, $scope, PortfolioService, StockScouterList, CurrentStockInfo) ->

  @scouterService = new StockScouterList()
  $scope.portfolioStocks = []
  topStocks = []
  symList = []
  $scope.showSellModal = false
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
        pos['inList'] = symList.some pos.symbol
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

  displayEditForm = (stock) ->
    $scope.showAddForm = false
    $scope.stockSymbol = stock.symbol
    $scope.positionId = stock.id
    $scope.sharesPurchased = stock.shares
    $scope.pricePaid = stock.purchase_price
    $scope.datePurchased = stock.purchase_date
    $scope.showEditForm = true

  submitEditPosition = ->
    newPos = new PortfolioService {id: $scope.positionId}
    newPos.symbol = $scope.stockSymbol
    newPos.purchase_price = $scope.pricePaid
    newPos.purchase_date = $scope.datePurchased
    newPos.shares = $scope.sharesPurchased
    newPos.$update newPos, ->
      @currentStockInfoService.raw().get {sym: newPos.symbol}, (data) ->
        origPos = $scope.portfolioStocks.find (oldPos) ->
          oldPos.id == newPos.id
        origPos.currentPrice = data.price
        origPos.rating = data.rating
        origPos.purchase_price = newPos['purchase_price']
        origPos.purchase_date = newPos['purchase_date']
        origPos.symbol = newPos['symbol']

        origPos.gainLoss = makingMoney origPos.purchase_price, origPos.currentPrice
        origPos.inList = symList.some origPos.symbol
        origPos.advice = getAdvice(origPos)
      $scope.stockSymbol = ""
      $scope.datePurchased = ""
      $scope.pricePaid = ""
      $scope.sharesPurchased = ""
      $scope.showEditForm = false
  cancelAddPosition = ->
    $scope.stockSymbol = ""
    $scope.datePurchased = ""
    $scope.pricePaid = ""
    $scope.sharesPurchased = ""
    $scope.showAddForm = false
    $scope.showEditForm = false
  cancelEditPosition = ->
    $scope.stockSymbol = ""
    $scope.datePurchased = ""
    $scope.pricePaid = ""
    $scope.sharesPurchased = ""
    $scope.showEditForm = false
    $scope.showEditForm = false

  $scope.comingSoon = ->
    alert("Coming Soon!!")

  displaySellPosition = (stock) ->
    $scope.sellStockId = stock.id
    $scope.sellStockSymbol = stock.symbol
    $scope.sellStockShares = stock.shares
    $("#sellModal").modal()
    $scope.showSellModal = true

  sellStock = ->
    oldPos = $scope.portfolioStocks.find (pos) ->
      pos.id == $scope.sellStockId
    position = new PortfolioService {
      id: $scope.sellStockId,
      sold_price: $scope.sellStockPrice,
      sold_date: $scope.sellStockDate,
      shares: $scope.sharesSold,
      sell_how_many: $scope.sellHowManyShares

    }
    position.$update position, ->
      if oldPos.shares > $scope.sharesSold
        oldPos.shares -= $scope.sharesSold
      else
        $scope.portfolioStocks = $scope.portfolioStocks.remove (pos) ->
          pos.id == oldPos.id
    $("#sellModal").modal("hide")
    true

  disableSomeShares = (val) ->
    $("#sharesSold").attr("disabled", val)
    true

  $scope.submitAddPosition = addPosition
  $scope.cancelAddPosition = cancelAddPosition
  $scope.submitEditPosition = submitEditPosition
  $scope.cancelEditPosition = cancelEditPosition
  $scope.displayEditForm = displayEditForm
  $scope.displaySellPosition = displaySellPosition
  $scope.disableSomeShares = disableSomeShares
  $scope.sellStock = sellStock

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



