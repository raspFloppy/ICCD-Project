class Level < ApplicationRecord
  has_many :student_progresses, dependent: :destroy
  has_many :students, through: :student_progresses

  validates :title, presence: true
  validates :code_snippet, presence: true
  validates :points, numericality: { greater_than: 0 }
end
