class Api::StockScouterController < ApplicationController
  require 'mechanize'
  def index
    agent = Mechanize.new
    stocks = []
    agent.get("http://investing.money.msn.com/investments/stockscouter-top-rated-stocks?sco=50") do |page|

      tbody = page.search("table.mnyindustrytopstock tbody")
      rows = tbody.search("tr")
      rows.each do |row|
        puts "##### #{row.children.size}"

        stock = {}
        stock['sym'] = row.children[0].text.strip
        stock['name'] = row.children[2].text.strip
        stock['overallRating'] = row.children[4].text.strip.to_i
        stock['coreRating'] = row.children[6].text.strip.to_i
        stock['price'] = row.children[8].text.strip.to_f
        stocks << stock

      end
    end
    #respond_to do |format|
      #format.json {
    render :json => stocks
    #end
  end

  def currentStockInfo
    agent = Mechanize.new
    stock = {}
    agent.get("http://investing.money.msn.com/investments/stock-price/?symbol=#{params['id']}") do |page|
      stock[:rating] = page.search("div.rat a").text().to_i
      stock[:price] = page.search("span.lp").text().to_f
    end
    render :json => stock
  end
end
