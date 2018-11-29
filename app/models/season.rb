class Season < ApplicationRecord
  belongs_to :champion, class_name: "Owner", optional: true
  belongs_to :second_place, class_name: "Owner", optional: true
  belongs_to :third_place, class_name: "Owner", optional: true
  belongs_to :last_place, class_name: "Owner", optional: true
end
