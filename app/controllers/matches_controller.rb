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

  def submit_duplicate
    create_match_from_replay( params[:unique_id], :allow_duplicates => true )
  end

  def upload
    if params['replay_file'].nil?
      redirect_to( new_match_path, :alert => 'No replay file specified' )
      return
    end

    unique_id = SecureRandom.hex

    tmp_file = File.join( 'public', 'tmp', unique_id )
    File.open( tmp_file, "wb" ) do |f|
      f.write( params['replay_file'].read )
    end

    create_match_from_replay( unique_id )
  end

  def create_match_from_replay( unique_id, options = {} )
    tmp_file = File.join( 'public', 'tmp', unique_id )

    info = Match.parse_replay( tmp_file )
    if info.nil?
      redirect_to( new_match_path, :alert => 'The replay could not be parsed' )
      return
    end
    if info['type'] != '1v1'
      redirect_to( new_match_path, :alert => 'The replay is not a 1v1' )
      return
    end

    winner = Player.find( :first, :conditions => [ 'lower(name) = ?', info['winner_name'].downcase ] )
    if winner.nil?
      redirect_to( new_match_path, :alert => 'Could not find player ' + info['winner_name'] )
      return
    end

    loser = Player.find( :first, :conditions => [ 'lower(name) = ?', info['loser_name'].downcase ] )
    if loser.nil?
      redirect_to( new_match_path, :alert => 'Could not find player ' + info['loser_name'] )
      return
    end

    replay_file = info['winner_name'] + '_vs_' + info['loser_name'] + '_' + Time.now.to_i.to_s + '.SC2Replay'

    @match = Match.new(
      :winner      => winner,
      :loser       => loser,
      :replay_file => replay_file,
      :map         => info['map'],
      :winner_race => info['winner_race'],
      :loser_race  => info['loser_race'],
      :start_time  => info['start_time'],
      :length      => info['length'],
      :sha1        => info['sha1'] )

    @duplicate = nil
    if !options[:allow_duplicates]
      @duplicate = Match.find_duplicate( @match.sha1, @match.length, @match.start_time )
    end

    respond_to do |format|
      if @duplicate
        @unique_id = unique_id
        format.html { render :action => "duplicate" }
      elsif @match.save
        FileUtils.mv( tmp_file, File.join( 'public', 'replays', replay_file ) )
        format.html { redirect_to '/' }
      else
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
