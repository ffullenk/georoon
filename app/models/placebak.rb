class Place
  extend ActiveModel::Naming
  include ActiveModel::Conversion

attr_accessor :id, :name, :distance, :latitude, :longitude


def persisted?
    false
  end

 def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

end