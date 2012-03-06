class Tournament < ActiveRecord::Base
	has_many :matches

	def self.week_diff( match_date, start_date )
		diff = match_date - start_date
		1 + ( diff / 7.days ).floor
	end

	def self.this_week
		week_diff Time.now.getlocal, Tournament.current.start_date
	end

	def self.current
		Tournament.all[0]
	end
end
