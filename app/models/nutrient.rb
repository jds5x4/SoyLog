class Nutrient < ActiveRecord::Base
  include NutrientsHelper

  has_many :flags, as: :flagable

  has_many :component_nutrients,                                autosave: true
  has_many :components,          through: :component_nutrients, autosave: true
  has_many :ingredients,         through: :components,          autosave: true
  # has_many :recipes,             through: :ingredients,         autosave: true

  attr_accessible :id, :name, :fda_rda

  accepts_nested_attributes_for :component_nutrients
  accepts_nested_attributes_for :components
  accepts_nested_attributes_for :ingredients
  # accepts_nested_attributes_for :recipes

  def self.identify
    "A Nutrient is the FDA recommended amount of a certain substance."
  end

end
