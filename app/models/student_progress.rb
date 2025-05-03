class StudentProgress < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :level

  validates :student_id, uniqueness: { scope: :level_id }
  validates :score, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
