include ActionView::Helpers::DateHelper
include ActionView::Helpers::TextHelper

class Match < ActiveRecord::Base
  belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
  belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'
  belongs_to :tournament

  validate :winner_is_not_loser
  
  before_save :calculate_points_and_set_time
  after_save :add_points
  before_destroy :remove_points

  def self.parse_replay( replay_file )
    script_file = File.join( 'lib', 'parse_replay.py' )
    output_file = File.join( 'public', 'tmp', SecureRandom.hex )

    success = system( script_file + ' ' + replay_file + ' > ' + output_file )
    raw_output = File.open( output_file ) { |f| f.read }
    File.delete output_file

    if success
      ActiveSupport::JSON.decode( raw_output )
    else
      nil
    end
  end

  def self.find_duplicate( sha1, length, start_time )
    duplicate = Match.find_by_sha1( sha1, :order => 'id DESC' )

    if !duplicate.nil? &&
      duplicate.length.between?( length - 30, length + 30 ) &&
      duplicate.start_time.between?( start_time - 5*60, start_time + 5*60 )
      duplicate
    else
      nil
    end
  end

  def self.race_image( short_race_name )
    return '/images/zerg_small.png'    if short_race_name == 'Z'
    return '/images/terran_small.png'  if short_race_name == 'T'
    return '/images/protoss_small.png' if short_race_name == 'P'
    nil
  end

  def self.map_image( map_name )
    canonical_name = map_name.downcase.gsub( ' ', '_' )

    [
      [ 'antiga_shipyard',  'antiga_shipyard' ],
      [ 'cloud_kingdom',    'cloud_kingdom_le' ],
      [ 'condemned_ridge',  'condemned_ridge' ],
      [ 'daybreak',         'daybreak_le' ],
      [ 'entombed_valley',  'entombed_valley' ],
      [ 'ohana',            'ohana_le' ],
      [ 'shakuras_plateau', 'shakuras_plateau' ],
      [ 'tal\'darim',       'tal\'darim_altar_le' ],
      [ 'shattered_temple', 'the_shattered_temple' ],
    ].each do |mapping|
      if canonical_name.include? mapping[0]
        return '/images/maps/' + mapping[1] + '.jpg'
      end
    end

    return '/images/maps/unknown.jpg'
  end

  def ago( time )
    local_time = time.getlocal
    local_match_time = self.time.getlocal

    if local_time.year != local_match_time.year
      return local_match_time.strftime( "%b %d %Y" )
    end

    if local_time.mon != local_match_time.mon || local_time.day != local_match_time.day
      return local_match_time.strftime( "%b %d" )
    end

    return local_match_time.strftime( "%l:%M %p" )
  end

  def pretty_length
    seconds = self.length
    return pluralize( seconds, 'second' ) if seconds < 60

    minutes = seconds / 60
    return pluralize( minutes, 'minute' )
  end

  def opponent( player )
    player.id == winner_id ? loser : winner
  end

  def win?( player )
    player.id == winner_id
  end

  def points( player )
    player.id == winner_id ? winner_points : loser_points
  end

  def winner_is_not_loser
    if winner_id == loser_id then
      errors.add_to_base( "A player can't play themself" )
    end
  end

  def calculate_points_and_set_time
    self.time = DateTime.now
    self.tournament = Tournament.current

    adjustment = Tournament.random_adjustment

    self.winner_points = 2*adjustment
    self.loser_points = -adjustment
  end

  def add_points
    winner_standing = Standing.where( :player_id => winner_id, :tournament_id => tournament.id ).first
    loser_standing = Standing.where( :player_id => loser_id, :tournament_id => tournament.id ).first

    winner_standing.update_attributes :points => winner_standing.points + winner_points
    loser_standing.update_attributes :points => loser_standing.points + loser_points
  end

  def remove_points
    winner_standing = Standing.where( :player_id => winner_id, :tournament_id => tournament.id ).first
    loser_standing = Standing.where( :player_id => loser_id, :tournament_id => tournament.id ).first

    winner_standing.update_attributes :points => winner_standing.points - winner_points
    loser_standing.update_attributes :points => loser_standing.points - loser_points
  end
end
