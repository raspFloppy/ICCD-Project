class Classroom < ApplicationRecord
  belongs_to :professor, class_name: "User"
  has_many :classroom_students, dependent: :destroy
  has_many :students, through: :classroom_students

  validates :name, presence: true
end
