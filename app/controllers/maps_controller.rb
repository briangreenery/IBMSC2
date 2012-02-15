class MapsController < ApplicationController
  # GET /maps
  # GET /maps.xml
  def index
    @maps = Map.all( :order => "lower( name )" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @maps }
    end
  end

  # POST /maps
  # POST /maps.xml
  def create
    Map.delete_all

    params[:maps].each do |number, name|
      if !name.empty?
        Map.create( :name => name )
      end
    end

    redirect_to '/'
  end
end
