module Api
  module V1
    class LevelsController < ApplicationController
      before_action :set_level, only: [ :show ]

      def index
        @levels = Level.all
        render json: @levels
      end

      def show
        render json: @level
      end

      private

      def set_level
        @level = Level.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Level not found" }, status: :not_found
      end
    end
  end
end
