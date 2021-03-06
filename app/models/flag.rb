class Flag < ActiveRecord::Base
  include FlagsHelper
  
  belongs_to :flagable, :polymorphic => true

  belongs_to :user

  attr_accessible :spam, :duplicate, :inapproriate, :dangerous, :vote, :comment

  before_validation :set_user
  def set_user
    self.user = @current_user
  end

  def self.identify
    "A Flag lets a User mark some object"
  end

  # def types
  #   [:spam, :duplicate, :inappropriate, :dangerous, :comment, :vote]
  # end

  def short_identify
    "# #{self.id}"
  end

  def identify
    "# #{self.id}#{", spam" if self.spam}#{", duplicate" if self.duplicate}#{", inapproriate" if self.inapproriate}#{", dangerous" if self.dangerous}"
  end

  def owner
    self.user
  end



end
