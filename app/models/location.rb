
class Location < ActiveRecord::Base
  delegate :url_helpers, to: 'Rails.application.routes' 
  belongs_to :tpieza
  belongs_to :user
  attr_accessible :address, :amueblada, :ascensor, :balconpatio, :banioprivado,
                  :city, :cocina, :detalle, :estacionamiento, :gimnasio, :gmaps,
                  :internet, :latitude, :lavadora, :longitude, :portero, :telefono, :tpieza_id, :tvcable,
                  :precio, :user, :image
  acts_as_gmappable :callback => :save_city
  
  geocoded_by :address   # can also be an IP address
  after_validation :geocode, :if => :address_changed?
  validates_presence_of :address, :precio
  validates_presence_of :image, :size => { :in => 0..2048.kilobytes }
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    
  
  
  def url
    url_helpers.location_path(self)
  end
  
  def gmaps4rails_address

  "#{self.address}" 
  end
  def gmaps4rails_infowindow
      if self.image
     "<a href=\"#{self.url}\"> #{self.address} <br/> <img src=\"#{self.image.url}\" width=\"150\" height=\"150\">"
   else
     "<a href=\"#{self.url}\"> #{self.address}"
  end

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
