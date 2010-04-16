class Category < ActiveRecord::Base
  has_many :dishes
  validates_presence_of :title
end
