
class Location < ActiveRecord::Base
  delegate :url_helpers, to: 'Rails.application.routes' 
  has_one :tpieza
  belongs_to :user
  attr_accessible :address, :amueblada, :ascensor, :balconpatio, :banioprivado,
                  :city, :cocina, :detalle, :estacionamiento, :gimnasio, :gmaps,
                  :internet, :latitude, :lavadora, :longitude, :portero, :telefono, :tpieza_id, :tvcable,
                  :precio, :user
  acts_as_gmappable :callback => :save_city
  
  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?
  
  def url
    url_helpers.location_path(self)
  end
  
  def gmaps4rails_address

  "#{self.address}" 
  end
  def gmaps4rails_infowindow
      
     "<a href=\"#{self.url}\"> #{self.address}"
  end
  
  def geocode?
  (!address.blank? && (lat.blank? || lng.blank?)) || address_changed?
  end

  def save_city(data)
  data["address_components"].each do |c|
    if c["types"].include? "city"
      self.city = c["long_name"]
    end
  end
  end


end
