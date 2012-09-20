class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.xml
  def index
    @matches = Match.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.xml
  def show
    @match = Match.find(params[:id])

    @replay_info = nil
    @map = nil    
    if !@match.replay_info.nil?
      @replay_info = ActiveSupport::JSON.decode( @match.replay_info )

      @map = @replay_info["map"].downcase.gsub( ' ', '_' )

      [
        [ 'antiga_shipyard', 'antiga_shipyard' ],
        [ 'cloud_kingdom', 'cloud_kingdom_le' ],
        [ 'condemned_ridge', 'condemned_ridge' ],
        [ 'daybreak', 'daybreak_le' ],
        [ 'entombed_valley', 'entombed_valley' ],
        [ 'ohana', 'ohana_le' ],
        [ 'shakuras_plateau', 'shakuras_plateau' ],
        [ 'tal\'darim', 'tal\'darim_altar_le' ],
        [ 'shattered_temple', 'the_shattered_temple' ],
      ].each do |mapping|
        if @map.include? mapping[0]
          @map = mapping[1]
          break
        end
      end
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /matches/new
  # GET /matches/new.xml
  def new
    @match = Match.new
    @players = Player.all.sort { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def upload
    if params['replay_file'].nil?
      redirect_to( new_match_path, :alert => "No replay file specified" )
      return
    end

    base_name = File.join( 'public/tmp', SecureRandom.hex )

    tmp_file = base_name + '.SC2Replay'
    info_file = base_name + '.info'

    File.open( tmp_file, "wb" ) do |f|
      f.write( params['replay_file'].read )
    end

    parse_successful = system( 'lib/parse_replay.py ' + tmp_file + ' > ' + info_file )
    replay_info_raw = File.open( info_file ) { |f| f.read }
    File.delete info_file

    if !parse_successful
      File.delete tmp_file
      redirect_to( new_match_path, :alert => replay_info_raw )
      return
    end

    replay_info = ActiveSupport::JSON.decode( replay_info_raw )

    winner = Player.find( :first, :conditions => [ "lower(name) = ?", replay_info["winner"].downcase ] )
    if winner.nil?
      File.delete tmp_file
      redirect_to( new_match_path, :alert => "Could not find player " + replay_info["winner"] )
      return
    end

    loser = Player.find( :first, :conditions => [ "lower(name) = ?", replay_info["loser"].downcase ] )
    if loser.nil?
      File.delete tmp_file
      redirect_to( new_match_path, :alert => "Could not find player " + replay_info["loser"] )
      return
    end

    replay_file = replay_info["winner"] + '_vs_' + replay_info["loser"] + '_' + Time.now.to_i.to_s + '.SC2Replay'

    match = Match.new( :winner => winner, :loser => loser, :replay_info => replay_info_raw, :replay_file => replay_file )

    respond_to do |format|
      if match.save
        FileUtils.mv( tmp_file, File.join( 'public/replays', replay_file ) )
        format.html { redirect_to '/' }
      else
        File.delete tmp_file
        format.html { render :action => "new" }
      end
    end
  end

  # POST /matches
  # POST /matches.xml
  def create
    @match = Match.new(params[:match])
    @players = Player.all.sort { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      if @match.save
        format.html { redirect_to '/' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.xml
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to '/' }
    end
  end
end
