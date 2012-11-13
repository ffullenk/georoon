# encoding: UTF-8
class PlacesController < ApplicationController

	def show
		@place = Place.find(params[:id])
		url = URI.escape('http://api.geonames.org/wikipediaSearch?q=' + @place.name + '&maxRows=1&username=ffullenk&lang=es')
	    
	    doc = Nokogiri::XML(open(url))


	    # Search for nodes by xpath
	   	@detalle =  doc.xpath('//entry').at_xpath("summary").content
	    @locations = Location.near([@place.latitude,@place.longitude], 10, :order => :distance)
	end


end
