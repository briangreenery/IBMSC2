#!/usr/bin/python2.7

import sys
import sc2reader
import hashlib
import json

path = sys.argv[1]

replay = sc2reader.load_replay( path, load_level=2 )

data = {}
data["type"] = replay.real_type
data["map"] = replay.map_name
data["length"] = int( replay.game_length.total_seconds() )
data["start_time"] = replay.start_time.strftime( "%s" )

for player in replay.players:
	if player.result is "Win":
		data["winner_name"] = player.name
		data["winner_race"] = player.play_race[0]
	else:
		data["loser_name"] = player.name
		data["loser_race"] = player.play_race[0]

unique_id = replay.map_hash

for player in sorted( replay.players, key = lambda player : player.url ):
	unique_id += player.url + player.result + player.color.hex + player.pick_race + player.play_race

for observer in sorted( replay.observers, key = lambda observer : observer.name ):
	unique_id += observer.name

data["sha1"] = hashlib.sha1( unique_id ).hexdigest()
print( json.dumps( data ) )
