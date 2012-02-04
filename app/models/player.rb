class Player < ActiveRecord::Base

  has_many :games_won, :class_name => "Match", :foreign_key => "winner_id", :dependent => :delete_all
  has_many :games_lost, :class_name => "Match", :foreign_key => "loser_id", :dependent => :delete_all

  validates :name, :presence => true
  validates_format_of :character_code, :with => /^$|^[0-9]{2,3}$/, :message => "must be 3 or 4 digits long"
  validates :points, :presence => true, :numericality => { :only_integer => true }

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
