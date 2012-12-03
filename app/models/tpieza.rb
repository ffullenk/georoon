class Tpieza < ActiveRecord::Base
  attr_accessible :nombre
  has_many :locations
end
