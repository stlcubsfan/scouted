class Api::PositionsController < ApplicationController
  before_filter :get_current_user

  def index
    if params[:style] == 'open'
      open_positions
    elsif params[:style] == 'closed'
      closed_positions
    else
      render :json => current_user.positions
    end
  end

  def create
    @position = Position.new(position_params)
    @position.user = current_user
    if @position.save
      render :json => @position, status: :created
    else
      render :json => @position.errors, status: :unprocessable_entity
    end

  end

  def update
    @position = Position.find(params[:id])
    if @position.user == @current_user
      if params[:sell_how_many] == 'someShares'
        if params[:shares].to_i > @position.shares
          render :json => {"error" => "Can't sell that many shares"}, status: :unprocessable_entity
          return
        end
        @newPosition = Position.new(update_position_params)
        @newPosition.symbol = @position.symbol
        @newPosition.purchase_date = @position.purchase_date
        @newPosition.purchase_price= @position.purchase_price
        @newPosition.user = @position.user
        @newPosition.id = nil

        @newPosition.save()
        shares = @position.shares - params[:shares].to_i
        if @position.update_attribute(:shares, shares)
          render :json => @position, status: :ok
        else
          render :json => @position.errors, status: :unprocessable_entity
        end
      else

        if @position.update_attributes(update_position_params)
          render :json => @position, status: :ok
        else

          render :json => @position.errors, status: :unprocessable_entity
        end
      end

    end
  end

  private

  def get_current_user
    @current_user = current_user
  end

  def open_positions
    positions = []
    positions = current_user.positions.open if (current_user)
    render :json => positions
  end

  def closed_positions
    positions = []
    positions = current_user.positions.closed if (current_user)
    puts positions
    render :json => positions
  end

  def position_params
    params.require(:position).permit(:symbol, :shares, :purchase_price, :purchase_date)
  end

  def update_position_params
    params.require(:position).permit(:id, :sold_price, :sold_date, :sell_how_many, :shares, :symbol, :purchase_price, :purchase_date)
  end
end
