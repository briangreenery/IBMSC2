class Standing < ActiveRecord::Base
	belongs_to :player
	belongs_to :tournament
	validates :points, :presence => true, :numericality => { :only_integer => true }
end
