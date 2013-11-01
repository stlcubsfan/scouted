class Api::PositionsController < ApplicationController

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
end
