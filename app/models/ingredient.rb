class Ingredient < ActiveRecord::Base
  include IngredientsHelper

  has_many :flags, as: :flagable

  belongs_to :recipe,    autosave: true
  belongs_to :component, autosave: true
  
  attr_accessible :servings, :component_id, :id, :recipe_id, :component_attributes, :component

  accepts_nested_attributes_for :component, allow_destroy: true
  accepts_nested_attributes_for :recipe, allow_destroy: true

  def self.identify
    "An Ingredient is the specific amount of a Component to use for a specific Recipe."
  end

  # def clone_with_associations
  #   new_ingredient = self.dup
  #   new_ingredient.save

  #   # new_ingredient.component = self.component
  #   # new_ingredient.save!
  #   new_ingredient
  # end

end
