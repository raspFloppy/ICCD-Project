module Api
  module V1
    class ClassroomsController < ApplicationController
      before_action :authorize_professor, except: [ :index, :show ]
      before_action :set_classroom, only: [ :show, :update, :destroy ]

      def index
        if current_user.professor?
          @classrooms = current_user.professor_classrooms
        else
          @classrooms = current_user.enrolled_classrooms
        end

        render json: @classrooms
      end

      def show
        if @classroom.professor_id == current_user.id || @classroom.students.include?(current_user)
          render json: @classroom.to_json(include: :students)
        else
          render json: { error: "You do not have access to this classroom" }, status: :forbidden
        end
      end

      def create
        @classroom = current_user.professor_classrooms.new(classroom_params)

        if @classroom.save
          render json: @classroom, status: :created
        else
          render json: { errors: @classroom.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @classroom.professor_id == current_user.id
          if @classroom.update(classroom_params)
            render json: @classroom
          else
            render json: { errors: @classroom.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "You do not have permission to update this classroom" }, status: :forbidden
        end
      end

      def destroy
        if @classroom.professor_id == current_user.id
          @classroom.destroy
          head :no_content
        else
          render json: { error: "You do not have permission to delete this classroom" }, status: :forbidden
        end
      end

      def add_student
        @classroom = current_user.professor_classrooms.find(params[:id])
        @student = User.student.find_by(email: params[:email])

        if @student.nil?
          render json: { error: "Student not found" }, status: :not_found
          return
        end

        @classroom_student = ClassroomStudent.new(classroom: @classroom, student: @student)

        if @classroom_student.save
          render json: @classroom.to_json(include: :students)
        else
          render json: { errors: @classroom_student.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def remove_student
        @classroom = current_user.professor_classrooms.find(params[:id])
        @student = User.find(params[:student_id])

        @classroom_student = ClassroomStudent.find_by(classroom: @classroom, student: @student)

        if @classroom_student
          @classroom_student.destroy
          render json: @classroom.to_json(include: :students)
        else
          render json: { error: "Student not found in this classroom" }, status: :not_found
        end
      end

      private

      def set_classroom
        if current_user.professor?
          @classroom = current_user.professor_classrooms.find(params[:id])
        else
          @classroom = current_user.enrolled_classrooms.find(params[:id])
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Classroom not found" }, status: :not_found
      end

      def classroom_params
        params.require(:classroom).permit(:name)
      end
    end
  end
end
