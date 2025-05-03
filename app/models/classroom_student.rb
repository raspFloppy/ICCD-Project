class ClassroomStudent < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :classroom

  validates :student_id, uniqueness: { scope: :classroom_id }
end
