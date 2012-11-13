class Place < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name

  private

  def attributes_protected_by_default
    []
  end
end
