#!/usr/bin/python2.7

import sys
import sc2reader
import json

def main():
	path = sys.argv[1]

	try:
		replay = sc2reader.load_replay( path, load_level=2 )

		data = {}
		data["map"] = replay.map_name

		if replay.length.mins > 0:
			data["length"] = str( replay.length.mins ) + ' minutes'
		else:
			data["length"] = str( replay.length.seconds ) + ' seconds'

		for team in replay.teams:
			for player in team.players:
				if team.result is "Win":
					data["winner"] = player.name
					data["winner_race"] = player.play_race
				else:
					data["loser"] = player.name
					data["loser_race"] = player.play_race

		print( json.dumps( data ) )
	except:
		print "The replay could not be parsed"
		exit( 1 )

if __name__ == '__main__':
	main()