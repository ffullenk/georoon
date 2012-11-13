class Place

attr_accessor :name, :distance


def persisted?
    false
  end

 def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

end