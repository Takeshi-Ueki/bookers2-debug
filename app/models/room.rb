class Room < ApplicationRecord
  has_many :room_users
  has_many :chats
end
