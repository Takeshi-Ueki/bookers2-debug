class RoomsController < ApplicationController
  def index

  end

  def new

  end

  def create
    @room = Room.new(room_params)
    @room.save
    redirect_to room_messeges_path
  end
  
  private
  def room_params
    params.permit(user_ids: [])
  end
end
