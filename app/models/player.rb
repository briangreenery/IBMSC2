class Player < ActiveRecord::Base

  has_many :games_won, :class_name => "Match", :foreign_key => "winner_id", :dependent => :delete_all
  has_many :games_lost, :class_name => "Match", :foreign_key => "loser_id", :dependent => :delete_all

  def name_with_code
    if character_code.nil?
      name
    else
      name + "." + character_code.to_s
    end
  end

	def rank
    Player.count( :conditions => ['points > ?', points] ) + 1
	end

end
