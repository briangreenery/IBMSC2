class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    @games_played = {}
    @games_played.default = 0

    Match.all.each do |match|
      @games_played[match.winner_id] += 1
      @games_played[match.loser_id] += 1
    end

    @players = Player.all.sort { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find( params[:id] )
    @matches = Match.order( 'time DESC, id DESC ' ).where( 'winner_id = ? or loser_id = ?', @player.id, @player.id )

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to players_path, :notice => 'Player was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
    end
  end
end
