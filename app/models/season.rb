class Season < ApplicationRecord
  belongs_to :champion, class_name: "Owner"
  belongs_to :second_place, class_name: "Owner"
  belongs_to :third_place, class_name: "Owner"
  belongs_to :last_place, class_name: "Owner"
end
