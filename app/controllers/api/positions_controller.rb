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
      if @position.update_attributes(position_params)
        render :json => @position, status: :ok
      else
        render :json => @position.errors, status: :unprocessable_entity
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
end
