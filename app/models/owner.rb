class Owner < ApplicationRecord
  has_many :teams
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
