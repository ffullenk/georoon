class Location < ActiveRecord::Base
  has_one :tpieza
  attr_accessible :address, :amueblada, :ascensor, :balconpatio, :banioprivado,
                  :city, :cocina, :detalle, :estacionamiento, :gimnasio, :gmaps,
                  :internet, :latitude, :lavadora, :longitude, :portero, :telefono, :tpieza_id, :tvcable
  acts_as_gmappable
  
  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?
  
  def gmaps4rails_address

  "#{self.address}" 
  end
  def gmaps4rails_infowindow
      " #{self.address}"
  end


end
