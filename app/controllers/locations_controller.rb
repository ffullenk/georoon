# encoding: UTF-8
class LocationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :destroy, :update]
  # GET /locations
  # GET /locations.json
  def buscar

    @search = Location.near(params[:search], 10, :order => :distance)

    @locations = @search.results
    @json = @locations.to_gmaps4rails

  end

  def search

    @search = Location.near(params[:search], 10, :order => :distance)
    
    @query = params[:search]
    @locations = @search
    @json = @locations.to_gmaps4rails
  end

  def index
    if params[:search].present?
      @locations = Location.near(params[:search], 10, :order => :distance)

    else
      @geopos = Geokit::Geocoders::MultiGeocoder.geocode('181.160.166.91')

      @locations = Location.near(@geopos.city, 10, :order => :distance)
    end

    @json = @locations.to_gmaps4rails

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @places = Gmaps4rails.places(@location.latitude,@location.longitude, 'AIzaSyB0VQ_kPLS7ReH8A1lxKAz5AM-5qkfeods',keyword = nil, 100, 'es', true)["results"]

  #= Gmaps4rails.places(@location.latitude,@location.longitude, "AIzaSyB0VQ_kPLS7ReH8A1lxKAz5AM-5qkfeods")

  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new
    @json = @location.to_gmaps4rails

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location].merge!(:user => current_user))

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'La habitación se ha guardado exitosamente.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'La habitación se ha guardado exitosamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
end
