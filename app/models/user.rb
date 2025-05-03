class User < ApplicationRecord
  has_secure_password

  enum role: { student: 0, professor: 1, admin: 2 }

  has_many :classroom_students, foreign_key: :student_id, dependent: :destroy
  has_many :enrolled_classrooms, through: :classroom_students, source: :classroom
  has_many :professor_classrooms, foreign_key: :professor_id, class_name: "Classroom", dependent: :destroy
  has_many :student_progresses, foreign_key: :student_id, dependent: :destroy
  has_many :completed_levels, through: :student_progresses, source: :level

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def student?
    role == "student"
  end

  def professor?
    role == "professor"
  end

  def admin?
    role == "admin"
  end
end
