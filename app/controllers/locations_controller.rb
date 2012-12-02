# encoding: UTF-8
class LocationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :destroy, :update]
  # GET /locations
  # GET /locations.json

  def search

    @search = Location.near(params[:search], 15, :order => :distance)
    
    @query = params[:search]
    @locations = @search
    
    @filtros = ajustaFiltros
    @precios = precios(@locations)
    @campos = self.campos
    @facets = facetas(@locations, @filtros)
    @json = @locations.to_gmaps4rails
  end

  def ajustaFiltros
    session[:filtros] ||= Hash.new
    
    if params[:rmv].present?
      @filtro = params[:rmv]
      
      if session[:filtros].has_key?(@filtro)
          session[:filtros].delete(@filtro)
      end
     end
    
    
    if params[:filtro].present?
      @filtro = params[:filtro]
      
      if !session[:filtros].has_key?(@filtro) 
        session[:filtros][@filtro] = true
      end
      
    end
    
    
    if params[:precio].present?
      @filtro = params[:precio]
        if !session[:filtros].has_key?(@filtro)
       
          session[:filtros][@filtro] = true
      end
    end


     if params[:idPlace].present?
      @filtro = params[:idPlace]
        if !session[:filtros].has_key?(@filtro)
       
          session[:filtros][@filtro] = true
      end
    end
    
    @filtros = session[:filtros]
    
    return @filtros
  end



  
  def index

    
    @geopos = Geokit::Geocoders::MultiGeocoder.geocode("158.251.4.48")
    #@geopos = Geokit::Geocoders::MultiGeocoder.geocode(request.ip)
    @locations = Location.near(@geopos.city, 20, :order => :distance)
    
    #agrega o quita filtros
    @filtros = ajustaFiltros

    #agrega facetas para locaciones (amoblada...internet...)
    @facets = facetas(@locations, @filtros)

    #selecciona locations que cumplan con los filtros
    @locations = filtraLocations(@locations, @filtros)


    @places = places(@locations,@filtros)
    @precios = precios(@locations)
    @json = @locations.to_gmaps4rails

    #campos (internet...amoblada...)
    @campos = self.campos
    logger.debug @facets
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end
  
  def filtraLocations(locations, filtros)
    tmp = Array.new  
    
    locations.each do |location|
      flag = false
      filtros.each do |key, value|
          
             if location.attributes[key] == true
               flag = true
             else
               precio = location.precio

               if precio <50000 && key == "1"
                flag = true
               end

               if precio >= 50000 && precio <100000 && key == "2"
                  flag = true
               end
               if precio >= 100000 && precio <150000 && key == "3"
                  flag = true
               end
               if precio >= 150000 && precio <200000 && key == "4"
                  flag = true
               end
              if precio >=200000 && key == "5"
                flag = true
              end

              if flag == false
                  places = buscarPlacesCercanos(location)
                  places.each do |place|
                    if place.id == key.to_i
                    flag = true
                    end
                  end
              end
             
              end
      end
      if flag == true
        tmp.push(location)
      end
    end
   
   if tmp.count >0
       locations = tmp
   end
   
   return locations
  end


  def buscarPlacesCercanos(location)

     url = 'http://api.geonames.org/findNearby?lat=' + location.latitude.to_s + '&lng=' + location.longitude.to_s + '&username=ffullenk&radius=10'
    doc = Nokogiri::XML(open(url))

    places = []
    # Search for nodes by xpath
    doc.xpath('//geoname').each do |geoname|
      name = geoname.at_xpath("toponymName").content
      #distance = geoname.at_xpath("distance").content
      latitude = geoname.at_xpath("lat").content
      longitude = geoname.at_xpath("lng").content
      id = geoname.at_xpath("geonameId").content
      place = Place.find_or_initialize_by_id(:id=>id, :name=>name, :latitude=>latitude, :longitude=>longitude)
      place.id = id
      place.save!
      places.push(place)
      
    end

    return places


  end


  def show
    @location = Location.find(params[:id])
    #@places = Gmaps4rails.places(@location.latitude,@location.longitude, 'AIzaSyB0VQ_kPLS7ReH8A1lxKAz5AM-5qkfeods',keyword = nil, 100, 'es', true)["results"]


    @places = buscarPlacesCercanos(@location)

    
  end

   def places(locations,filtros)
      lugaresCercanos = Hash.new(0)
     
    locations.each do |location|
      places = buscarPlacesCercanos(location)
        places.each do |place|

          if !filtros.has_key? (place.id.to_s)
         
            lugaresCercanos[place.id] += 1
          end
        end
    end

    return lugaresCercanos

  end


  
  def precios(locations)
    @precios = Hash.new(0)
    
    locations.each do |location|
      precio = location.precio
      
      if precio < 50000
          @precios["1"] += 1
      end
      
      if precio >= 50000 && precio <100000
          @precios["2"] += 1
        
      end
      
      if precio >= 100000 && precio <150000
          @precios["3"] += 1

      end
      
      if precio >= 150000 && precio <200000
          @precios["4"] += 1

      end
      
      if precio >=200000
          @precios["5"] += 1
      end
      
    end
    
    @filtros.each do |key, value|
      if key == "1"
        @filtros[key] = "Hasta $50.000"
      end
         if key == "2"
        @filtros[key] = "$50.000 a $100.000"
      end
         if key == "3"
        @filtros[key] = "$100.000 a $150.000"
      end
         if key == "4"
        @filtros[key] = "$150.000 a $200.000"
      end
      if key == "5"
        @filtros[key] = "Más de $200.000"
      end
    end
    

    return @precios
  end
  
  def campos
    campos =  Hash.new
    
    campos.store("amueblada","Amoblado" )
    campos.store("ascensor","Ascensor" )
    campos.store("balconpatio","Balcón o Patio" )
    campos.store("banioprivado","Baño privado" )
    campos.store("cocina","Cocina" )
    campos.store("estacionamiento","Estacionamiento" )
    campos.store("gimnasio","Gimnasio" )
    campos.store("internet","Internet" )
    campos.store("lavadora","Lavadora" )
    campos.store("portero","Portero" )
    campos.store("telefono","Teléfono" )
    campos.store("tvcable","TVcable" )
  
    return campos
  end

  def facetas(locations, filtros)
    facets = Hash.new(0)
    
    campos = self.campos
                      
    locations.each do |location|
       location.attributes.each_pair do |name, value|
         if (campos.has_key? name) && (!filtros.has_key? name) 
            if value == true
                  facets[name] += 1
          
            end
          end
       end
    end

    return facets
  end
  
  def precioMax(locations)
    max = 0
    locations.each do |location|
      if location.precio > max
        max = location.precio
      end
    end
    return max
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
