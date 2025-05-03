module Api
  module V1
    class StudentProgressesController < ApplicationController
      before_action :authorize_student, except: [ :index, :show ]

      def index
        if current_user.professor?
          student_ids = current_user.professor_classrooms.flat_map { |c| c.students.pluck(:id) }
          @progresses = StudentProgress.where(student_id: student_ids)
        else
          @progresses = current_user.student_progresses
        end

        render json: @progresses.to_json(include: :level)
      end

      def create
        @progress = current_user.student_progresses.find_or_initialize_by(level_id: params[:level_id])
        @progress.assign_attributes(progress_params)

        if @progress.save
          render json: @progress, status: :created
        else
          render json: { errors: @progress.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def progress_params
        params.require(:student_progress).permit(:completed, :score)
      end
    end
  end
end
