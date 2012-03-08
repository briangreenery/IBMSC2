class Map < ActiveRecord::Base
	def url
		'http://wiki.teamliquid.net/starcraft2/index.php?title=Special%3ASearch&search=' + URI.escape( name ) + '&go=Go'
	end
end
