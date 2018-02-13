class User < ActiveRecord::Base
  has_many :player_ones
  has_many :player_twos

  def initialize(name)
    @name = name
  end

end
